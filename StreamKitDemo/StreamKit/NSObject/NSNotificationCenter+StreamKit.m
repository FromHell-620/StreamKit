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

static const void * const SKNotificationObserverKey = &SKNotificationObserverKey;

@implementation NSNotificationCenter (StreamKit)

- (NSNotificationCenter*)sK_addEventBlockWithObserver:(NSObject *)observer name:(NSNotificationName)aName aObject:(id)anObject block:(id)eventBlock
{
    NSParameterAssert(aName);
    NSParameterAssert(eventBlock);
    NSParameterAssert(observer);
    /* cache blocks aName<-->blocks_set */
    NSHashTable *observers = objc_getAssociatedObject(self, SKNotificationObserverKey);
    if (observers == nil) {
        observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPersonality capacity:1];
        objc_setAssociatedObject(self, SKNotificationObserverKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (![observers containsObject:observer]) {
        [observers addObject:observer];
    }
    NSMutableDictionary* blocks_table = objc_getAssociatedObject(observer, SKNotificationKey);
    if (!blocks_table) {
        blocks_table = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(observer, SKNotificationKey, blocks_table, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
            NSDictionary *cache = objc_getAssociatedObject(target, SKNotificationKey);
            NSArray* allKeys = cache.keyEnumerator.allObjects;
            [allKeys enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self sk_removeNotificationWithObserver:target name:obj];
            }];
        });
        [classes addObject:hook_class];
    }
    
    /* realize noti callback */
    SEL block_action = sel_registerName("sk_notification:");
    if (!class_getInstanceMethod(self.class, block_action)) {
        IMP block_imp = imp_implementationWithBlock(^(id target,NSNotification *param){
            NSHashTable *table = objc_getAssociatedObject(target, SKNotificationObserverKey);
            NSArray *objs = table.objectEnumerator.allObjects;
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary* block_cache = objc_getAssociatedObject(obj, SKNotificationKey);
                NSSet* blocks = [block_cache objectForKey:param.name];
                [blocks enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                    SK_BasicForceify(obj, void(^)(id))(param);
                }];
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

- (void)sk_removeNotificationWithObserver:(id)observer name:(NSNotificationName)name {
    NSDictionary* block_table = objc_getAssociatedObject(observer, SKNotificationKey);
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

+ (void)sk_removeNotificationWithObserver:(id)observer name:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] sk_removeNotificationWithObserver:observer name:name];
}

@end
