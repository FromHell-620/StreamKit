//
//  UIAlertAction+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertAction (StreamKit)

+ (UIAlertAction* (^)(NSString* title,UIAlertActionStyle style,void(^handle)(UIAlertAction* action)))sk_init;

- (UIAlertAction* (^)(BOOL enabled))sk_enabled;

@end

@interface UIAlertController (StreamKit)

+ (UIAlertController* (^)(NSString* title,NSString* message,UIAlertControllerStyle preferredStyle))sk_init;

- (UIAlertController* (^)(UIAlertAction* action))sk_addAction;

- (UIAlertController* (^)(UIAlertAction* preferredAction))sk_preferredAction NS_AVAILABLE_IOS(9_0);

- (UIAlertController* (^)(void(^handle)(UITextField* textField)))sk_addTextFieldWithConfigurationHandler;

- (UIAlertController* (^)(NSString* title))sk_title;

- (UIAlertController* (^)(NSString* message))sk_message;

@end
