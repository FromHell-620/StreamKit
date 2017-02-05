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


/**
  register a notification.
 @discussion register a notification with a block. 
             the notification's observer is own.
 @code 
 self.sk_addNotification(aName,^(NSNotification* noti){
    your code;
 });
 @endcode
 
 @return a block which receive a NotificationName and a event block.
         the event block should invoke when the notification is received.
 */
- (NSNotificationCenter* (^)(NSNotificationName aName,SKNotificationBlock block))sk_addNotification;

/**
 register a notification
 @discussion register a notification with a block.
             the notification's observer is own.
 @code
 self.sk_addNotification(aName,anObject,^(NSNotification* noti){
    your code;
 });
 @endcode
 
 @return a block which receive a NotificationName,an Object and a event block.
         the event block should invoke when the notification is received.
 */
- (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,SKNotificationBlock block))sk_addNotificationWithObject;

/**
 register a notification
 @discussion register a notification with a block.
             the notification's observer is own.
             if the returned block receive a observer,the notification will remove when the observer dealloc.
 @code
 self.sk_addNotification(aName,anObject,observer,^(NSNotification* noti){
    your code;
 });
 @endcode
 
 @return a block which receive a NotificationName,an Object and a event block.
         the event block should invoke when the notification is received.
         the nofication will remove when the observer dealloc.the observer can be nil.
 */
- (NSNotificationCenter* (^)(NSNotificationName aName,id observer,SKNotificationBlock block))sk_addNotificationToObserver;


/**
 register a notification
 @discussion register a notification with a block.
             the notification's observer is own.
             if the returned block receive a observer,the notification will remove when the observer dealloc.
 @code
 self.sk_addNotification(aName,anObject,observer,^(NSNotification* noti){
    your code;
 });
 @endcode
 
 @return a block which receive a NotificationName,an Object and a event block.
         the event block should invoke when the notification is received.
         the nofication will remove when the observer dealloc.the observer can be nil.
 */
- (NSNotificationCenter* (^)(NSNotificationName aName,id observer,id anObject,SKNotificationBlock block))sk_addNotificationToObserverWithObject;


/**
 remove a notification 

 @code
 self.sk_removeNotification(aName);
 @endcode
 
 @return a block which receive a NotificationName.
 */
- (NSNotificationCenter* (^)(NSNotificationName aName))sk_removeNotification;

#pragma mark- defaultCenter

/**
 see NSNotificationCenter
 */
+ (NSNotificationCenter* (^)(NSNotificationName aName,SKNotificationBlock block))sk_addNotification;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,SKNotificationBlock block))sk_addNotificationWithObject;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id observer,SKNotificationBlock block))sk_addNotificationToObserver;

+ (NSNotificationCenter* (^)(NSNotificationName aName,id observer,id anObject,SKNotificationBlock block))sk_addNotificationToObserverWithObject;

+ (NSNotificationCenter* (^)(NSNotificationName aName))sk_removeNotification;

@end
