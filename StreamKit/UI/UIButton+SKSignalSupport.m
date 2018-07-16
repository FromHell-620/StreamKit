//
//  UIButton+SKSignalSupport.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/28.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UIButton+SKSignalSupport.h"
#import "UIControl+SKSignalSupport.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "SKCommand.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKMetaMarco.h"
#import "SKKeyPathMarco.h"
#import "SKObjectifyMarco.h"
#import <objc/runtime.h>

@implementation UIButton (SKSignalSupport)

- (SKSignal *)sk_clickSignal {
    return [self sk_signalForControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation UIButton (SKCommandSupport)

static void * UIButtonCommandDisposable = &UIButtonCommandDisposable;

- (SKCommand *)sk_command {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSk_command:(SKCommand *)command {
    objc_setAssociatedObject(self, @selector(sk_command), command, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    SKCompoundDisposable *disposable = objc_getAssociatedObject(self, UIButtonCommandDisposable);
    [disposable dispose];
    if (command == nil) return;
    SKDisposable *enableDisposable = [command.enabledSignal setKeyPath:@sk_keypath(self,enabled) onObject:self nilValue:@YES];
    
    SKDisposable *subscriberDisposable = [[self sk_clickSignal] subscribeNext:^(id x) {
        [command execute:x];
    }];
    disposable = [SKCompoundDisposable disposableWithdisposes:@[enableDisposable,subscriberDisposable]];
    objc_setAssociatedObject(self, UIButtonCommandDisposable, disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

