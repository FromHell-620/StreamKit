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

- (UIControl* (^)(UIControlEvents controlEvents,void(^block)(__kindof UIControl* target)))sk_addEventBlock
{
    return ^ UIControl* (UIControlEvents controlEvents,void(^block)(__kindof UIControl* target)) {
        if (block) {
            char* sel_name = calloc(10, sizeof(char));
            sprintf(sel_name, "%ld",(unsigned long)controlEvents);
            strcat(sel_name, ":");
            SEL invoke_name = sel_registerName(sel_name);
            free(sel_name);
            if (!class_getInstanceMethod(NSClassFromString(@"UIControl"), invoke_name)) {
                IMP imp = imp_implementationWithBlock(^(__unsafe_unretained id target,__kindof UIControl* control) {
                    NSMapTable* cacheBlocks = objc_getAssociatedObject(target, (__bridge const void *)target);
                    char* event_name = strdup(sel_getName(invoke_name));
                    NSMutableSet* blocks = [cacheBlocks objectForKey:@(strtoul(event_name, NULL, 0))];
                    free(event_name);
                    [blocks enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                        ((void(^)(UIControl*))obj)(control);
                    }];
                });
                class_addMethod(NSClassFromString(@"UIControl"), invoke_name, imp, "v@:@");
            }
            
            NSMapTable* cacheBlocks = objc_getAssociatedObject(self, (__bridge const void*)self);
            if (!cacheBlocks) {
                cacheBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
                objc_setAssociatedObject(self, (__bridge const void*)self, cacheBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            NSMutableSet* blocks = [cacheBlocks objectForKey:@(controlEvents)];
            if (blocks == nil) {
                blocks = [NSMutableSet set];
                [cacheBlocks setObject:blocks forKey:@(controlEvents)];
            }
            [blocks addObject:block];
            [self addTarget:self action:invoke_name forControlEvents:controlEvents];
        }
        return self;
    };
}

- (UIControl* (^)(UIControlEvents controlEvents))sk_removeEventBlock
{
    return ^ UIControl* (UIControlEvents controlEvents) {
        NSMapTable* cacheBlocks = objc_getAssociatedObject(self, (__bridge const void*)self);
        NSMutableSet* blocks = [cacheBlocks objectForKey:@(controlEvents)];
        [blocks removeAllObjects];
        return self;
    };
}

- (UIControl* (^)())sk_removeAllEventBlock
{
    return ^ UIControl* (id target) {
        NSMapTable* cacheEvent = objc_getAssociatedObject(self, (__bridge const void *)(self));
        [cacheEvent removeAllObjects];
        return self;
    };
}

@end
