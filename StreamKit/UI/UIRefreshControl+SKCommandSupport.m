//
//  UIRefreshControl+SKCommandSupport.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/16.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UIRefreshControl+SKCommandSupport.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "SKCommand.h"
#import "UIControl+SKSignalSupport.h"
#import "SKMetaMarco.h"
#import "SKObjectifyMarco.h"
#import "SKKeyPathMarco.h"
#import <objc/runtime.h>

@implementation UIRefreshControl (SKCommandSupport)

static void* UIRefreshControlECommandDisposable = &UIRefreshControlECommandDisposable;

- (SKCommand *)sk_command {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)set_skCommand:(SKCommand *)command {
    SKDisposable *disposable = objc_getAssociatedObject(self, UIRefreshControlECommandDisposable);
    [disposable dispose];
    if (command == nil) return;
    SKDisposable *enbaleDisposable = [command.enabledSignal setKeyPath:@sk_keypath(self,enabled) onObject:self nilValue:@YES];
    SKDisposable *subscriberDisposable = [[[[self sk_signalForControlEvents:UIControlEventValueChanged] map:^id(id x) {
        return [[[[command execute:x]
                  catchTo:[SKSignal empty]]
                 ignoreValues]
                concat:[SKSignal return:x]];
    }] concat] subscribeNext:^(UIRefreshControl  *x) {
        [x endRefreshing];
    }];
    disposable = [SKCompoundDisposable disposableWithdisposes:@[enbaleDisposable,subscriberDisposable]];
    objc_setAssociatedObject(self, UIRefreshControlECommandDisposable, disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(sk_command), command, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
