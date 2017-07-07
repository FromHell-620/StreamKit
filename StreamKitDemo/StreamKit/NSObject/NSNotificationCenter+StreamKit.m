//
//  NSNotificationCenter+StreamKit.m
//  StreamKitDemo
//
//  Created by 苏南 on 17/1/6.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSNotificationCenter+StreamKit.h"
#import "NSObject+StreamKit.h"
#import "SKObjectifyMarco.h"
@import ObjectiveC.runtime;
@import ObjectiveC.message;

static const void * const SKNotificationKey = &SKNotificationKey;

@implementation NSNotificationCenter (StreamKit)

- (NSNotificationCenter*)sK_addEventBlockWithObserver:(NSObject *)observer name:(NSNotificationName)aName aObject:(id)anObject block:(id)eventBlock
{
    NSParameterAssert(aName);
    NSParameterAssert(eventBlock);
    /* cache blocks aName<-->blocks_set */
    NSMutableDictionary* blocks_table = objc_getAssociatedObject(self, SKNotificationKey);
    if (!blocks_table) {
        blocks_table = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, SKNotificationKey, blocks_table, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableSet* blocks_set = [blocks_table objectForKey:aName];
    if (!blocks_set) {
        blocks_set = [NSMutableSet set];
        [blocks_table setObject:blocks_set forKey:aName];
    }
    [blocks_set addObject:eventBlock];
    
    /* hook 'deallocMethod' */
    static NSMutableSet* classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = [NSMutableSet set];
    });
    Class hook_class = observer.class;
    if (hook_class&&![classes containsObject:hook_class]) {
        StreamHookMehtod(hook_class, "dealloc", ^(NSObject* target) {
            NSArray* allKeys = blocks_table.keyEnumerator.allObjects;
            [allKeys enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self sk_removeNotificationWithName:obj];
            }];
        });
        [classes addObject:hook_class];
    }
    
    /* realize noti callback */
    SEL block_action = sel_registerName("sk_notification:");
    if (!class_getInstanceMethod(self.class, block_action)) {
        IMP block_imp = imp_implementationWithBlock(^(id target,id param){
            NSDictionary* block_cache = objc_getAssociatedObject(self, SKNotificationKey);
            NSSet* blocks = [block_cache objectForKey:aName];
            [blocks enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                SK_BasicForceify(obj, void(^)(id))(param);
            }];
        });
        class_addMethod(object_getClass(self), block_action, block_imp, "v@:@");
    }
    [self addObserver:self selector:block_action name:aName object:anObject];
    return self;
}

- (NSNotificationCenter* (^)(NSNotificationName aName,SKNotificationBlock block))sk_addNotification
{
    return ^ NSNotificationCenter* (NSNotificationName aName,SKNotificationBlock block) {
        return [self sK_addEventBlockWithObserver:nil name:aName aObject:nil block:block];
    };
}

- (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,SKNotificationBlock block))sk_addNotificationWithObject
{
    return ^ NSNotificationCenter* (NSNotificationName aName,id anObject,SKNotificationBlock block) {
        return [self sK_addEventBlockWithObserver:nil name:aName aObject:anObject block:block];
    };
}

- (NSNotificationCenter* (^)(NSNotificationName aName,id observer,SKNotificationBlock block))sk_addNotificationToObserver
{
    return ^ NSNotificationCenter* (NSNotificationName aName,id observer,SKNotificationBlock block) {
        return [self sK_addEventBlockWithObserver:observer name:aName aObject:nil block:block];
    };
}

- (NSNotificationCenter* (^)(NSNotificationName aName,id observer,id anObject,SKNotificationBlock block))sk_addNotificationToObserverWithObject
{
    return ^ NSNotificationCenter* (NSNotificationName aName,id observer,id anObject,SKNotificationBlock block) {
        return [self sK_addEventBlockWithObserver:observer name:aName aObject:anObject block:block];
    };
}

- (void)sk_removeNotificationWithName:(NSNotificationName)name {
    NSDictionary* block_table = objc_getAssociatedObject(self, SKNotificationKey);
    NSMutableSet* block_set = [block_table objectForKey:name];
    [block_set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeObserver:self name:name object:nil];
    }];
    [block_set removeAllObjects];
}

+ (NSNotificationCenter* (^)(NSNotificationName aName,SKNotificationBlock block))sk_addNotification
{
    return ^ NSNotificationCenter* (NSNotificationName aName,SKNotificationBlock block) {
        return [[NSNotificationCenter defaultCenter] sK_addEventBlockWithObserver:nil name:aName aObject:nil block:block];
    };
}

+ (NSNotificationCenter* (^)(NSNotificationName aName,id anObject,SKNotificationBlock block))sk_addNotificationWithObject
{
    return ^ NSNotificationCenter* (NSNotificationName aName,id anObject,SKNotificationBlock block) {
        return [[NSNotificationCenter defaultCenter] sK_addEventBlockWithObserver:nil name:aName aObject:anObject block:block];
    };
}

+ (NSNotificationCenter* (^)(NSNotificationName aName,id observer,SKNotificationBlock block))sk_addNotificationToObserver
{
    return ^ NSNotificationCenter* (NSNotificationName aName,id observer,SKNotificationBlock block) {
        return [[NSNotificationCenter defaultCenter] sK_addEventBlockWithObserver:observer name:aName aObject:nil block:block];
    };
}

+ (NSNotificationCenter* (^)(NSNotificationName aName,id observer,id anObject,SKNotificationBlock block))sk_addNotificationToObserverWithObject
{
    return ^ NSNotificationCenter* (NSNotificationName aName,id observer,id anObject,SKNotificationBlock block) {
        return [[NSNotificationCenter defaultCenter] sK_addEventBlockWithObserver:observer name:aName aObject:anObject block:block];
    };
}

+ (void)sk_removeNotificationWithName:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] sk_removeNotificationWithName:name];
}

@end
