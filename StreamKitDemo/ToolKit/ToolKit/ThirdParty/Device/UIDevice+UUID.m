//
//  UIDevice+UUID.m
//  CaiLianShe
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import "UIDevice+UUID.h"
#import <iAd/iAd.h>
#import <AdSupport/AdSupport.h>
//#import "NSString+Encode.h"
#import "NSString+MD5.h"

@implementation UIDevice (UUID)
/**
 * 获得本机设备的IDFA
 * @param:
 * @return:
 * @notes :
 */
//+ (NSString*)IDFA
//{
//    static NSString *idfa = nil;
//    if (idfa == nil) {
//        NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
//        [adSupportBundle load];
//        
//        if (adSupportBundle == nil) {
//            return @"";
//        }
//    }
//    
//    Class pkClass = NSClassFromString(@"ASIdentifierManager");
//    if (pkClass) {
//        if ([[ASIdentifierManager sharedManager] respondsToSelector:@selector(advertisingIdentifier)]
//            && [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
//             return  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        }
//    }
//    return nil;
//}

+ (NSString *)IDFA {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+(NSString *)uuidForIDFA
{
    NSString *idfa = [self IDFA];
    if (idfa.length > 0) {
        return [idfa md5String];
    }
    return nil;
}

@end
