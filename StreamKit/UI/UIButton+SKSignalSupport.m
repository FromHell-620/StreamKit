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

static void * UIButtonEnableSingalDisposable = &UIButtonEnableSingalDisposable;

- (SKCommand *)sk_command {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSk_command:(SKCommand *)command {
    objc_setAssociatedObject(self, @selector(sk_command), command, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    SKCompoundDisposable *disposable = objc_getAssociatedObject(self, UIButtonEnableSingalDisposable);
    [disposable dispose];
    if (command == nil) return;
    SKDisposable *enableDisposable = [command.enabledSignal setKeyPath:@sk_keypath(self,enabled) onObject:self nilValue:@YES];
    disposable = [SKCompoundDisposable disposableWithdisposes:@[enableDisposable]];
    @unsafeify(self)
    [disposable addDisposable:[SKDisposable disposableWithBlock:^{
        @strongify(self)
        [self removeTarget:self action:@selector(sk_commandExecute:) forControlEvents:UIControlEventTouchUpInside];
    }]];
    objc_setAssociatedObject(self, UIButtonEnableSingalDisposable, disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(sk_commandExecute:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sk_commandExecute:(id)send {
    [self.sk_command execute:send];
}

@end

