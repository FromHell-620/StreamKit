//
//  NSObject+EZSDeallocBell.m
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import "NSObject+EZSDeallocBell.h"
#import <objc/runtime.h>

@interface EZSDeallocBell : NSObject

@property (nonatomic, readonly, copy) EZSVoidBlock callback;

- (instancetype)initWithBlock:(nonnull EZSVoidBlock)block;

@end

@implementation EZSDeallocBell

- (instancetype)initWithBlock:(EZSVoidBlock)block {
    if (self = [super init]) {
        _callback = [block copy];
    }
    return self;
}

- (void)dealloc {
    if (self.callback) {
        self.callback();
    }
}

@end


@implementation NSObject (EZSDeallocBell)

- (void)addDeallocCallback:(EZSVoidBlock)block {
    EZSDeallocBell *bell = [[EZSDeallocBell alloc] initWithBlock:block];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(bell), bell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
