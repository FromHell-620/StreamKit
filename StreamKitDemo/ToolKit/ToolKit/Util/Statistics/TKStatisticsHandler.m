//
//  TKStatisticsHandler.m
//  ToolKit
//
//  Created by chunhui on 16/4/10.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#define DAY_PER_SEC 24*60*60
#define CACHE_KEEP_TIME DAY_PER_SEC*7


#import "TKStatisticsHandler.h"

#import "TKStatisticsHandler.h"
#import "TKStatisticsItem.h"
#import "TKAppInfo.h"
#import "TKCommonTools.h"
#import "TKFileUtil.h"

@interface TKStatisticsHandler()<NSStreamDelegate>
{
    FILE *_readLogFile;
}
@property(nonatomic , strong) NSOutputStream *outputStream;
@property(nonatomic , assign) NSInteger totalWrite;
@property(nonatomic , assign) NSInteger threshold;
/**
 *  单个日志文件最长保留时间，超过后会创建新的文件 n second
 */
@property(nonatomic , assign) NSTimeInterval logFileMaxDuration;
@property(nonatomic , assign) UIBackgroundTaskIdentifier backgroundIdentifier;
@property(nonatomic , strong) NSLock *backgronndWriteLock;
@property(nonatomic , strong) NSLock *writeLock;
@property(nonatomic , strong) NSLock *itemLock; //添加记录锁
@property(nonatomic , strong) NSString *appVersion;
@property(atomic    , assign) BOOL writingLog;
@property(nonatomic , strong) NSMutableArray *logItems;

/*
 * 统计的读取
 */
@property(nonatomic , strong) NSMutableArray *logfilesArray;
@property(nonatomic , assign) NSInteger readFileIndex;
@property(nonatomic , strong) NSMutableDictionary *pagesFileDict;//每页对应的文件
@property(nonatomic , strong) NSMutableDictionary *pageOffsetDict;//每页对应的偏移
@property(nonatomic , assign) NSInteger currentPage; //当前页面
@end

@implementation TKStatisticsHandler

+(void)StatisticsEnterPoint:(id)__unused object
{
    @autoreleasepool {
        
        [[NSThread currentThread] setName:@"TKStatistics"];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
}

+(NSThread *)StatisticsThread
{
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc]initWithTarget:[self class] selector:@selector(StatisticsEnterPoint:) object:nil];
        [thread start];
    });
    
    return thread;
}


-(instancetype)initWithThreshold:(NSInteger)thresHold maxLogDuration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        _threshold = thresHold;
        _logFileMaxDuration = duration;
        _readLogFile = NULL;
        
        self.backgronndWriteLock = [[NSLock alloc]init];
        self.writeLock = [[NSLock alloc]init];
        self.itemLock  = [[NSLock alloc]init];
        self.logItems  = [[NSMutableArray alloc]init];
        self.writeLock = false;
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [self loadLogFiles];
        
        self.appVersion = [TKAppInfo appVersion];
        
        [self open:false];
        
    }
    return self;
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self performSelector:@selector(close) onThread:[[self class]StatisticsThread] withObject:nil waitUntilDone:true];
    
    if (_readLogFile) {
        fclose(_readLogFile);
        _readLogFile = NULL;
    }
    
}

-(NSString *)currentLogPath
{
    return [self.logfilesArray lastObject];
}

//-(void)appEnterBackgroundNotification:(NSNotification *)notification
//{
//    self.backgroundIdentifier = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
//        [[UIApplication sharedApplication]endBackgroundTask:self.backgroundIdentifier];
//        self.backgroundIdentifier = UIBackgroundTaskInvalid;
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        [self.backgronndWriteLock lock];
//        
//        [[self class] removeCache];
//        
//        [self.backgronndWriteLock unlock];
//        
//        [[UIApplication sharedApplication]endBackgroundTask:self.backgroundIdentifier];
//        self.backgroundIdentifier = UIBackgroundTaskInvalid;
//        
//    });
//}

-(void)open:(BOOL)useNew
{
    NSString *path = nil;
    if (!useNew && [self.logfilesArray count] > 0) {
        path =[self.logfilesArray lastObject];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSDictionary *info = [fm attributesOfItemAtPath:path error:nil];
        if (info) {
            NSDate *date = [info fileCreationDate];
            if ([[NSDate date]timeIntervalSinceDate:date] > self.logFileMaxDuration) {
                //文件创建时间超过阈值需要上传
                path = nil;
            }
        }
    }
    
    if (path.length == 0){
        path = [self dataPath];
        [self.logfilesArray addObject:path];
    }
    
    if ([NSThread currentThread] != [[self class] StatisticsThread]){
        [self performSelector:@selector(openWithPath:) onThread:[[self class] StatisticsThread] withObject:path waitUntilDone:useNew];
    }else{
        [self openWithPath:path];
    }
    
}

-(void)openWithPath:(NSString *)path
{
    [self.writeLock lock];
    
    if (_outputStream) {
        [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_outputStream close];
        
        _outputStream = nil;
    }
    _outputStream = [[NSOutputStream alloc]initToFileAtPath:path append:true];
    _outputStream.delegate = self;
    [_outputStream open];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.writeLock unlock];
}


-(void)close
{
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream close];
}

-(void)loadLogFiles
{
    if (_logfilesArray == nil) {
        _logfilesArray = [[NSMutableArray alloc]init];
    }
    
    NSString *logDir = [[self class]logDirecotry];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDir]) {
        [fileManager createDirectoryAtPath:logDir withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:logDir error:nil];
    
    files = [files sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        
        NSArray *i1 = [obj1 componentsSeparatedByString:@"-"];
        NSArray *i2 = [obj2 componentsSeparatedByString:@"-"];
        
        if(i1.count > 2 && i2.count > 2){
            return [i1[1] longLongValue] > [i2[1] longLongValue];
        }
        return true;
    }];
        
    for (NSString *name in files) {
        
        if ([name hasPrefix:@"ios-"] && [name hasSuffix:@"log"]) {
            [_logfilesArray addObject:[logDir stringByAppendingPathComponent:name]];
        }
    }
}

-(void)Log:(TKLogLevel)level key:(NSString *)key param:(NSDictionary *)param date:(NSDate *)date duration:(NSTimeInterval)duration
{
    [self Log:level key:key andParam:param date:date duration:duration];
}

-(void)Log:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args date:(NSDate *)date duration:(NSTimeInterval)duration
{
    [self Log:level key:key andParam:args date:date duration:duration];
}


-(void)Log:(TKLogLevel)level key:(NSString *)key andParam:(id )param date:(NSDate *)date duration:(NSTimeInterval)duration
{
    if(date == nil){
        date = [NSDate date];
    }
    
    TKStatisticsItem *item = [[TKStatisticsItem alloc]init];
    item.level = level;
    item.key   = key;
    if ([param isKindOfClass:[NSDictionary class]]) {
        item.param = param;
    }else{
        item.args  = param;
    }
    item.timeStamp = [date timeIntervalSinceReferenceDate];
    item.duration  = duration;
    item.cuid      = self.cuid;
    
    [self performSelector:@selector(tryLogItem:) onThread:[[self class]StatisticsThread] withObject:item waitUntilDone:NO];
}

-(void)tryLogItem:(TKStatisticsItem *)item
{
    [self.itemLock lock];
    
    if (self.writingLog || _logItems.count > 0) {
        [self.logItems addObject:item];
        [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }else{
        self.writingLog = true;
        [self performSelector:@selector(logItem:) onThread:[[self class]StatisticsThread] withObject:item waitUntilDone:false];
    }
    
    [self.itemLock unlock];
}

-(void)logItem:(TKStatisticsItem *)item
{
    self.writingLog = true;
    NSMutableString *content = [[NSMutableString alloc]init];
    
    NSString *jsonStr = @"";
    id param = item.param;
    if (param == nil) {
        param = item.args;
    }
    
    if (param != nil && ([param isKindOfClass:[NSDictionary class]] || [param isKindOfClass:[NSArray class]])) {
//        @try {
        
        NSData *jsonParam = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonParam encoding:NSUTF8StringEncoding];
        
//        } @catch (NSException *exception) {
//            return;
//        } @finally {
//            
//        }

    }else{
        
        return;
        
    }
    
    NSTimeInterval timestamp = [[NSDate date]timeIntervalSince1970];
    
//    /*
//     * 每行中存储内容
//     * id | level | key | param | 时间戳 | duration | app version
//     */
//    [content appendFormat:@"%.0f|%@|%@|%@|%f|%f|%@\n",timestamp*10000,[self levelName:item.level],item.key,jsonStr,timestamp,item.duration,self.appVersion];

    /**
     *  每行存储内容
     *  ${type}\t${timestamp}\t${cuid}\t${detail_json}
     */
    [content appendFormat:@"%d\t%.0f\t%@\t%@\n",item.dataType,timestamp*1000,self.cuid?:@"",jsonStr];
    
    [self.writeLock lock];
    NSInteger realWrite = [_outputStream write:(const uint8_t *)[content UTF8String] maxLength:[content length]];
    _totalWrite += realWrite;
    [self checkOverThreshold];
    [self.writeLock unlock];
    self.writingLog = false;
    
}

-(NSArray *)logItemsAtPath:(NSString *)path
{
    return [self logItemsAtPath:path levelFilter:-1];
}

-(NSArray *)logItemsAtPath:(NSString *)path levelFilter:(TKLogLevel)level
{
    return [self logItemsAtPath:path levelFilter:level dateFileter:nil];
}

-(NSArray *)logItemsAtPath:(NSString *)path levelFilter:(TKLogLevel)level dateFileter:(NSDate *)date
{
    FILE *file = fopen([path UTF8String], "r");
    NSMutableArray *items = [[NSMutableArray alloc]init];
    TKStatisticsItem *item = nil;
    NSTimeInterval interval = 0;
    if (date) {
        interval = [date timeIntervalSinceReferenceDate];
    }
    
    int size = 10240;
    char *buffer = (char *)malloc(size);
    
    while (fgets(buffer, size, file)){
        
        if (level < 0 || level == [self nameLevel:buffer[0]]) {
            
            NSString *line = [[NSString alloc] initWithCString:(const char *)buffer encoding:NSUTF8StringEncoding];
            
            item = [TKStatisticsItem DeserializeFromContent:line];
            if (item && item.timeStamp > interval) {
                [items addObject:item];
            }
        }
    }
    
    free(buffer);
    fclose(file);
    
    return items;
}

-(NSArray *)logItemsWithFilterLevel:(TKLogLevel)level date:(NSDate *)date countlimit:(NSInteger)count
{
    if(_currentPage < 0){
        _currentPage = 0;
    }
    
    if (_pageOffsetDict == nil) {
        _pageOffsetDict = [[NSMutableDictionary alloc]init];
    }
    
    if (_pagesFileDict) {
        _pagesFileDict = [[NSMutableDictionary alloc]init];
    }
    
    NSNumber *key = @(_currentPage);
    if (![_pagesFileDict objectForKey:key]) {
        [_pagesFileDict setObject:@(_readFileIndex) forKeyedSubscript:key];
    }
    
    if (![_pageOffsetDict objectForKey:key]) {
        NSInteger offset = 0;
        if (_readLogFile) {
            offset = ftell(_readLogFile);
        }
        [_pageOffsetDict setObject:@(offset) forKey:key];
    }
    
    int num = 0;
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    TKStatisticsItem *item = nil;
    NSTimeInterval interval = 0;
    if (date) {
        interval = [date timeIntervalSinceReferenceDate];
    }
    
    int size = 10240;
    char *buffer = (char *)malloc(size);
    
    while (num < count) {
        
        if (_readLogFile == NULL) {
            if (_readFileIndex < [_logfilesArray count]) {
                NSString *path = [_logfilesArray objectAtIndex:_readFileIndex];
                _readFileIndex++;
                _readLogFile = fopen([path UTF8String], "r");
            }else{
                break;
            }
        }
        if (_readLogFile == NULL) {
            break;
        }
        
        while (fgets(buffer, size, _readLogFile)){
            
            if (level < 0 || level == [self nameLevel:buffer[0]]) {
                
                NSString *line = [[NSString alloc] initWithCString:(const char *)buffer encoding:NSUTF8StringEncoding];
                item = [TKStatisticsItem DeserializeFromContent:line];
                if (item && item.timeStamp > interval) {
                    [items addObject:item];
                    num++;
                    if (num >= count) {
                        break;
                    }
                }
            }
        }
        if (num < count) {
            //需要读取下一个文件
            _readLogFile = NULL;
        }
    }
    
    ++_currentPage;
    
    free(buffer);
    return items;
}

-(NSArray *)preLogItemsWithFilterLevel:(TKLogLevel)level date:(NSDate *)date countlimit:(NSInteger)count
{
    _currentPage -= 2;
    if (_currentPage < -1) {
        return nil;
    }
    
    if (_currentPage < 0) {
        _currentPage = 0;
    }
    
    NSNumber *key = @(_currentPage);
    NSInteger fileIndex = [[_pagesFileDict objectForKey:key] integerValue];
    if (fileIndex != _readFileIndex) {
        _readFileIndex = fileIndex;
        if (_readLogFile != NULL) {
            fclose(_readLogFile);
            _readLogFile = NULL;
        }
    }
    
    if (_readLogFile == NULL ) {
        NSString *path = [_logfilesArray objectAtIndex:_readFileIndex];
        _readLogFile = fopen([path UTF8String], "r");
    }
    
    NSInteger offset = [[_pageOffsetDict objectForKey:key] integerValue];
    if (_readLogFile) {
        fseek(_readLogFile, offset, SEEK_SET);
    }
    
    return [self logItemsWithFilterLevel:level date:date countlimit:count];
}

-(void)clearFilter
{
    if (_readLogFile) {
        fclose(_readLogFile);
        _readLogFile = NULL;
    }
    _readFileIndex = 0;
    [_pageOffsetDict removeAllObjects];
    [_pagesFileDict removeAllObjects];
}


-(NSString *)levelName:(TKLogLevel)level
{
    switch (level) {
        case TKLogLevelInfo:
            return @"I";
        case TKLogLevelError:
            return @"E";
        default:
            break;
    }
    return @"D";
}
-(TKLogLevel)nameLevel:(char )name
{
    if (name == 'I') {
        return TKLogLevelInfo;
    }else if (name == 'D'){
        return TKLogLevelDebug;
    }else if (name == 'E'){
        return TKLogLevelError;
    }
    
    return -1;
}


-(void)checkOverThreshold
{
    if(_totalWrite > _threshold){
        //reopen
        [self open:true];
        _totalWrite  = 0;
    }
}

+(NSString *)logDirecotry
{
    NSString *path = [TKFileUtil docPath];
    return [TKFileUtil pathForDir:path pathComponent:@"log" ];
}

-(NSString *)dataPath
{
    NSString *uuid = [[TKCommonTools uuid] lowercaseString];
    NSString *path = [[[self class] logDirecotry] stringByAppendingPathComponent:[NSString stringWithFormat:@"ios-%.0f-%@.log",[[NSDate date]timeIntervalSince1970]*1000,uuid]];
        
    return path;
}

+(void)removeCache
{
    NSString *logDir = [self logDirecotry];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:logDir error:nil];
    
    for (NSString *file in files) {
        if ([file hasPrefix:@"ios_"] && [file hasSuffix:@"log"]) {
            NSString *path = [logDir stringByAppendingPathComponent:file];
            NSDictionary *attr = [fileManager attributesOfItemAtPath:path error:nil];
            
            NSDate *mdate = [attr objectForKey:NSFileModificationDate];
            NSTimeInterval interval =[[NSDate date] timeIntervalSinceDate:mdate];
            
            if (interval > CACHE_KEEP_TIME) {
                [fileManager removeItemAtPath:path error:nil];
            }
            
        }
    }
}

+(NSArray *)currentLogPaths
{
    NSString *logDir = [self logDirecotry];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:logDir error:nil];
    NSMutableArray *dirFiles = [[NSMutableArray alloc]init];
    for (NSString *path in files) {
        [dirFiles addObject:[logDir stringByAppendingPathComponent:path]];
    }
    
    return dirFiles;
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if(eventCode == NSStreamEventHasSpaceAvailable){
        TKStatisticsItem *item = nil;
        [self.itemLock lock];
        if([_logItems count] > 0){
            item = [_logItems firstObject];
            [_logItems removeObjectAtIndex:0];
        }else{
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        [self.itemLock unlock];
        if (item) {
            [self logItem:item];
        }
    }
}

@end

