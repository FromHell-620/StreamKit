//
//  NSNotificationCenter+StreamKit.h
//  StreamKitDemo
//
//  Created by 苏南 on 17/1/6.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (StreamKit)

- (NSNotificationCenter* (^)(NSNotificationName aName,void(^block)(NSNotification* noti)))sk_addNotification;

- (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,void(^block)(NSNotification* noti)))sk_addNotificationWithObject;

- (NSNotificationCenter* (^)(NSNotificationName aName))sk_removeNotification;

#pragma mark- defaultCenter
+ (NSNotificationCenter* (^)(NSNotificationName aName,void(^block)(NSNotification* noti)))sk_addNotification;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,void(^block)(NSNotification* noti)))sk_addNotificationWithObject;

+ (NSNotificationCenter* (^)(NSNotificationName aName))sk_removeNotification;

@end
