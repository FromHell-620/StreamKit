//
//  UIView+SKCommand.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/21.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UIView+SKCommand.h"
#import "SKCommand.h"
#import "SKSignal.h"
#import "SKKeyPathMarco.h"
#import "StreamObserver.h"
#import "SKObjectifyMarco.h"
#import "SKMetaMarco.h"
#import "UIView+ReactiveX.h"
@import ObjectiveC.runtime;

static const void *UIViewSKCommandKey = &UIViewSKCommandKey;

static const void *UIViewHasExistActionKey = &UIViewHasExistActionKey;

@implementation UIView (SKCommand)

- (void)sk_setCommand:(SKCommand *)sk_command {
    objc_setAssociatedObject(self, UIViewSKCommandKey, sk_command, OBJC_ASSOCIATION_RETAIN);
    if (sk_command == nil)  return;
    SK(self,userInteractionEnabled) = sk_command.enabledSignal;
    
    BOOL hasExist = [(NSNumber *)objc_getAssociatedObject(self, UIViewSKCommandKey) boolValue];
    if (hasExist == YES) return ;
    
    @weakify(self)
    [[self sk_eventSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.sk_command execute:x];
    }];
    
    objc_setAssociatedObject(self, UIViewHasExistActionKey, @YES, OBJC_ASSOCIATION_COPY);
    
}

- (SKCommand *)sk_command {
    return objc_getAssociatedObject(self, UIViewSKCommandKey);
}

@end
