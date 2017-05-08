//
//  UITextField+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UITextField+ReactiveX.h"
#import "UIControl+ReactiveX.h"
#import "UITextField+StreamKit.h"
#import "SKObjectifyMarco.h"
#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation UITextField (ReactiveX)

- (SKSignal*)sk_signal {
    return [self sk_signalForControlEvents:UIControlEventAllEditingEvents];
}

- (SKSignal*)sk_textSignal {
    return [[self sk_signal] map:^id(UITextField* x) {
        return x.text;
    }];
}

- (SKSignal*)sk_shouldBeginSignal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        self.sk_textFieldShouldBeginEditing(^BOOL(UITextField* textField) {
            return [[subscriber sendNextWithReturnValue:textField] boolValue];
        });
    }];
}

- (SKSignal*)sk_shouldChangeCharactersSignal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        self.sk_textFieldShouldChangeCharactersInRange(^BOOL(UITextField* textField,NSRange range,NSString* string){
            return [[subscriber sendNextWithReturnValue:string] boolValue];
        });
    }];
}

@end
