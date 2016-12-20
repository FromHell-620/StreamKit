//
//  UIControl+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/15.
//  Copyright © 2016年 苏南. All rights reserved.
//

#import "UIControl+StreamKit.h"
#import <objc/runtime.h>

static const void* block_key = &block_key;

@implementation UIControl (StreamKit)

- (UIControl* (^)(BOOL enabled))sk_enabled
{
    return ^ UIControl* (BOOL enabled) {
        return ({self.enabled = enabled;self;});
    };
}
- (UIControl* (^)(BOOL selected))sk_selected
{
    return ^ UIControl* (BOOL selected) {
        return ({self.selected = selected;self;});
    };
}

- (UIControl* (^)(BOOL highlighted))sk_highlighted
{
    return ^ UIControl* (BOOL highlighted) {
        return ({self.highlighted = highlighted;self;});
    };
}

- (UIControl* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment
{
    return ^ UIControl* (UIControlContentVerticalAlignment contentVerticalAlignment) {
        return ({self.contentVerticalAlignment = contentVerticalAlignment;self;});
    };
}

- (UIControl* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment
{
    return ^ UIControl* (UIControlContentHorizontalAlignment contentHorizontalAlignment) {
        return ({self.contentHorizontalAlignment = contentHorizontalAlignment;self;});
    };
}

- (UIControl* (^)(id target,UIControlEvents controlEvents,void(^block)(id target)))sk_addTargetBlock
{
    return ^ UIControl* (id target,UIControlEvents controlEvents,void(^block)(id target)) {
        if (block&&target) {
            static NSMapTable* cacheTargetAction = nil;
            static dispatch_semaphore_t lock = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cacheTargetAction = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
                lock = dispatch_semaphore_create(1);
                objc_setAssociatedObject(object_getClass(self), block_key, cacheTargetAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            });
            NSMutableDictionary* targetAction = [cacheTargetAction objectForKey:target];
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            if (!targetAction) {
                targetAction = [NSMutableDictionary dictionary];
                [cacheTargetAction setObject:targetAction forKey:target];
            }
            [targetAction setObject:block forKey:@(controlEvents)];
            dispatch_semaphore_signal(lock);
            [self addTarget:self action:@selector(targetAction:) forControlEvents:controlEvents];
        }
        return self;
    };
}

- (UIControl* (^)(id target,UIControlEvents controlEvents))sk_removeTargetBlock
{
    return ^ UIControl* (id target,UIControlEvents controlEvents) {
        NSMapTable* cacheEvent = objc_getAssociatedObject(object_getClass(self), block_key);
        NSMutableDictionary* targetAction = [cacheEvent objectForKey:target];
        [targetAction removeObjectForKey:@(controlEvents)];
        return self;
    };
}

- (UIControl* (^)(id target))sk_removeAllTargetBlock
{
    return ^ UIControl* (id target) {
        NSMapTable* cacheEvent = objc_getAssociatedObject(object_getClass(self), block_key);
        [cacheEvent removeObjectForKey:target];
        return self;
    };
}

- (UIControl* (^)())sk_clearTargetBlock
{
    return ^ UIControl* {
        NSMapTable* cacheEvent = objc_getAssociatedObject(object_getClass(self), block_key);
        [cacheEvent removeAllObjects];
        return self;
    };
}

#pragma mark- private
- (void)targetAction:(__kindof UIControl*)control
{
    NSMapTable* caches = objc_getAssociatedObject(object_getClass(self), block_key);
    for (id target in control.allTargets) {
        NSMutableDictionary* targetAction = [caches objectForKey:target];
        [targetAction enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSUInteger controlEvent = [key unsignedIntegerValue];
            if (controlEvent&control.allControlEvents) {
                void(^block)(id target) = obj;
                block(target);
            }
        }];
    }
}

@end
