//
//  UIAlertAction+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIAlertAction+StreamKit.h"

@implementation UIAlertAction (StreamKit)

+ (UIAlertAction* (^)(NSString* title,UIAlertActionStyle style,void(^handle)(UIAlertAction* action)))sk_init
{
    return ^ UIAlertAction* (NSString* title,UIAlertActionStyle style,void(^handle)(UIAlertAction* action)) {
        return [self actionWithTitle:title style:style handler:handle];
    };
}

- (UIAlertAction* (^)(BOOL enabled))sk_enabled
{
    return ^ UIAlertAction* (BOOL enabled) {
        return ({self.enabled = enabled;self;});
    };
}

@end

@implementation UIAlertController (StreamKit)

+ (UIAlertController* (^)(NSString* title,NSString* message,UIAlertControllerStyle preferredStyle))sk_init
{
    return ^ UIAlertController* (NSString* title,NSString* message,UIAlertControllerStyle preferredStyle) {
        return [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    };
}

- (UIAlertController* (^)(UIAlertAction* action))sk_addAction
{
    return ^ UIAlertController* (UIAlertAction* action) {
        return ({[self addAction:action];self;});
    };
}

- (UIAlertController* (^)(UIAlertAction* preferredAction))sk_preferredAction
{
    return ^ UIAlertController* (UIAlertAction* preferredAction) {
        return ({self.preferredAction = preferredAction;self;});
    };
}

- (UIAlertController* (^)(void(^handle)(UITextField* textField)))sk_addTextFieldWithConfigurationHandler
{
    return ^ UIAlertController* (void(^handle)(UITextField* textField)) {
        return ({[self addTextFieldWithConfigurationHandler:handle];self;});
    };
}

- (UIAlertController* (^)(NSString* title))sk_title
{
    return ^UIAlertController* (NSString* title) {
        return ({self.title = title;self;});
    };
}

- (UIAlertController* (^)(NSString* message))sk_message
{
    return ^ UIAlertController* (NSString* message) {
        return ({self.message = message;self;});
    };
}

@end
