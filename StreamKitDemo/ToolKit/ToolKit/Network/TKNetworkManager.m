//
//  FDNetworkManager.m
//  Find
//
//  Created by chunhui on 15/5/9.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKNetworkManager.h"

#define TEST 0

@interface TKNetworkManager ()

@property(nonatomic , strong) AFHTTPSessionManager *sessionManager;

@property(nonatomic , strong) Reachability *reachability;

@property(nonatomic , copy)   NSString *clientP12Path;
@property(nonatomic , copy)   NSString *clientPassword;

@property(nonatomic , strong) NSMutableArray *ignoreErrorPaths;

#if TEST

@property(nonatomic , assign) BOOL tokenTest;

#endif



@end

@implementation TKNetworkManager

+(TKNetworkManager *)sharedInstance
{
    static TKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKNetworkManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanageNotification:) name:kReachabilityChangedNotification object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            [_reachability startNotifier];
        });
        
        __weak typeof(self) wself = self;
        [_sessionManager setSessionDidReceiveAuthenticationChallengeBlock : ^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential =nil;
            if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                if([wself.sessionManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if(credential) {
                        disposition =NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                // client authentication
                SecIdentityRef identity = NULL;
                SecTrustRef trust = NULL;
                
                NSFileManager *fileManager =[NSFileManager defaultManager];
                
                if(![fileManager fileExistsAtPath:wself.clientP12Path])
                {
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                    
                }else{
                    
                    NSData *PKCS12Data = [NSData dataWithContentsOfFile:wself.clientP12Path];
                    
                    if ([wself extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data withPassword:wself.clientPassword])
                    {
                        SecCertificateRef certificate = NULL;
                        SecIdentityCopyCertificate(identity, &certificate);
                        const void*certs[] = {certificate};
                        CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                        credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                        disposition =NSURLSessionAuthChallengeUseCredential;
                    }
                }
            }
            *_credential = credential;
            return disposition;
        }];
        
#if TEST
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenTestNotification:) name:@"tokenTestNotification" object:nil];
        
        
#endif
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)loadCerWithPath:(NSString *_Nonnull)cerPath
{
    if (cerPath.length == 0) {
        return;
    }
    [self loadCersWithPaths:@[cerPath]];
    
}

-(void)loadCersWithPaths:(NSArray *_Nonnull)cerPaths
{
    NSMutableSet *cers = [[NSMutableSet alloc]initWithCapacity:cerPaths.count];
    for (NSString *path in cerPaths) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            [cers addObject:data];
        }
    }
    if (cers.count > 0) {
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        policy.pinnedCertificates = [cers allObjects];
        policy.validatesDomainName = false;
        policy.allowInvalidCertificates = true;
        self.sessionManager.securityPolicy = policy;
    }
}

-(void)loadAllDefaultCers
{
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate ];
    policy.validatesDomainName = false;
    policy.allowInvalidCertificates = true;
    self.sessionManager.securityPolicy = policy;
}

-(void)loadClientP12:(NSString *)p12Path password:(NSString *)password
{
    self.clientP12Path = p12Path;
    self.clientPassword = password;
}

-(NSString *)clientP12Path
{
    return _clientP12Path;
}

-(NSString *)clientPassword
{
    return _clientPassword;
}

-(BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data withPassword:(NSString *)password
{
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary* optionsDictionary = [NSDictionary dictionaryWithObject:password
                                                                  forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    _sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

-(NSTimeInterval)timeoutInterval
{
    return _sessionManager.requestSerializer.timeoutInterval;
}

-(void)setExtraHeaderParam:(NSDictionary *)extraHeaderParam
{
    for (NSString *key in extraHeaderParam) {
        NSString * value = [NSString stringWithFormat:@"%@",extraHeaderParam[key]];
        [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
}

-(void)setIgnoreErrorCodePaths:(NSArray *)ignorePaths
{
    if (ignorePaths.count == 0) {
        return;
    }
    _ignoreErrorPaths = [[NSMutableArray alloc]initWithArray:ignorePaths];
    
}

-(NSDictionary *)chageResponseToDict:(id)response
{
    
#if TEST
    
    if (_tokenTest) {
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc]init];
        mdict[@"errno"] = @"20002";
        mdict[@"time"] = @1453361583;
        mdict[@"msg"] = @"token失效:10006";
        
        return mdict;
    }
    
#endif
    
    
    if ([response isKindOfClass:[NSData class]]) {
        
        @try {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            
            return dict;
        }
        @catch (NSException *exception) {
#if DEBUG
            NSLog(@"change respose failed :\n%@\n",exception);
            NSArray *callstack = [NSThread callStackSymbols];
            NSLog(@"call tree is:\n%@\n",callstack);
#endif
        }
        
    }
    return response;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    return [_sessionManager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [self chageResponseToDict:responseObject];
        [self handleResponse:responseObject forRequest:task.currentRequest];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task , error);
        }
    }];
    
}

- (nullable NSURLSessionDataTask *)RAWGET:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    return [_sessionManager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task , error);
        }
    }];
    
}


- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [_sessionManager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [self chageResponseToDict:responseObject];
        [self handleResponse:responseObject forRequest:task.currentRequest];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task , error);
        }
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [_sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [self chageResponseToDict:responseObject];
        [self handleResponse:responseObject forRequest:task.currentRequest];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

-(nullable NSURLSessionTask *)download:(NSString *)URLString
                              progress:(NSProgress * __nullable __autoreleasing * __nullable)progress
                           destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                     completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * __nullable filePath, NSError * __nullable error))completionHandler
{
    NSURL *url = [NSURL URLWithString:URLString];
    if (url == nil) {
        return  nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [_sessionManager downloadTaskWithRequest:request progress:nil destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response , filePath , error);
        }
    }];
    
    [task resume];
    
    return task;
    
}


-(BOOL)handleResponse:(NSDictionary *)response forRequest:(NSURLRequest *)request
{
    NSInteger errNum = 0;
    if ([response isKindOfClass:[NSDictionary class]]) {
        errNum = [[response objectForKey:@"errno"] integerValue];
        if (errNum != 0 && [_delegate respondsToSelector:@selector(checkError:responseData:forRequest:)]) {
            [_delegate checkError:errNum responseData:response forRequest:request];
        }
    }
    
    return errNum == 0;
}

#if TEST

-(void)tokenTestNotification:(NSNotification *)notification
{
    _tokenTest = YES;
}

#endif

#pragma mark - net check

-(void)startNotifier
{
    [_reachability startNotifier];
}

-(void)stopNotifier
{
    [_reachability stopNotifier];
}

-(BOOL)networkReachable
{
    if (_reachability) {
        NetworkStatus status =  [_reachability currentReachabilityStatus];
        return status != NotReachable;
    }
    return YES;
}

-(NetworkStatus)networkStatus
{
    return [_reachability currentReachabilityStatus];
}


-(void)reachabilityChanageNotification:(NSNotification *)notification
{
    NSDictionary *statusInfo = @{@"status":@([_reachability currentReachabilityStatus])};
    [[NSNotificationCenter defaultCenter]postNotificationName:kTKNetworkChangeNotification object:nil userInfo:statusInfo];
}

NSString *kTKNetworkChangeNotification = @"_kTKNetworkChangeNotification";

@end
