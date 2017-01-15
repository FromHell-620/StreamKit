//
//  NSNotificationCenter+StreamKit.h
//  StreamKitDemo
//
//  Created by 苏南 on 17/1/6.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SKNotificationBlock)(NSNotification* noti);
@interface NSNotificationCenter (StreamKit)

- (NSNotificationCenter* (^)(NSNotificationName aName,SKNotificationBlock block))sk_addNotification;

- (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,SKNotificationBlock block))sk_addNotificationWithObject;

- (NSNotificationCenter* (^)(NSNotificationName aName,id observer,SKNotificationBlock block))sk_addNotificationToObserver;

- (NSNotificationCenter* (^)(NSNotificationName aName,id observer,id anObject,SKNotificationBlock block))sk_addNotificationToObserverWithObject;

- (NSNotificationCenter* (^)(NSNotificationName aName))sk_removeNotification;

#pragma mark- defaultCenter
+ (NSNotificationCenter* (^)(NSNotificationName aName,SKNotificationBlock block))sk_addNotification;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,SKNotificationBlock block))sk_addNotificationWithObject;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id observer,SKNotificationBlock block))sk_addNotificationToObserver;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id observer,id anObject,SKNotificationBlock block))sk_addNotificationToObserverWithObject;

+ (NSNotificationCenter* (^)(NSNotificationName aName))sk_removeNotification;

@end
