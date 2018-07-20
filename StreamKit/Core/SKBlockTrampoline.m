//
//  SKBlockTrampoline.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/18.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKBlockTrampoline.h"
#import <objc/runtime.h>
#import "SKValueNil.h"

@interface SKBlockTrampoline ()

@property (nonatomic,copy) id block;

@property (nonatomic,copy) NSArray *argments;

@end

@implementation SKBlockTrampoline

- (instancetype)initWithBlock:(id)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (id)invokeBlock:(id)block arguments:(NSArray *)Arguments {
    NSCParameterAssert(block);
    SKBlockTrampoline *trampoline = [[SKBlockTrampoline alloc] initWithBlock:block];
    return [trampoline invokeWithArguments:Arguments];
}

- (id)invokeWithArguments:(NSArray *)arguments {
    SEL sel = [self blockSelWithArgumentCount:arguments.count];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:sel]];
    invocation.target = self;
    invocation.selector = sel;
    [arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = obj == SKValueNil.ValueNil ? nil : obj;
        [invocation setArgument:&obj atIndex:idx + 2];
    }];
    [invocation invoke];
    __unsafe_unretained id result;
    [invocation getReturnValue:&result];
    return result;
}

- (SEL)blockSelWithArgumentCount:(NSInteger)count {
    NSAssert(count <= 10,@"Block argument count should <= 10");
    NSMutableString *selString = [NSMutableString string];
    for (int i=0; i<count; i++) {
        [selString appendString:i == 0 ? @"_:" : @":"];
    }
    return sel_getUid(selString.UTF8String);
}

- (id)_:(id)o1 {
    id (^b)(id) = self.block;
    return b(o1);
}

- (id)_:(id)o1 :(id)o2 {
    id (^b)(id,id) = self.block;
    return b(o1,o2);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 {
    id (^b)(id,id,id) = self.block;
    return b(o1,o2,o3);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 {
    id (^b)(id,id,id,id) = self.block;
    return b(o1,o2,o3,o4);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 :(id)o5 {
    id (^b)(id,id,id,id,id) = self.block;
    return b(o1,o2,o3,o4,o5);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 :(id)o5 :(id)o6 {
    id (^b)(id,id,id,id,id,id) = self.block;
    return b(o1,o2,o3,o4,o5,o6);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 :(id)o5 :(id)o6 :(id)o7 {
    id (^b)(id,id,id,id,id,id,id) = self.block;
    return b(o1,o2,o3,o4,o5,o6,o7);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 :(id)o5 :(id)o6 :(id)o7 :(id)o8 {
    id (^b)(id,id,id,id,id,id,id,id) = self.block;
    return b(o1,o2,o3,o4,o5,o6,o7,o8);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 :(id)o5 :(id)o6 :(id)o7 :(id)o8 :(id)o9 {
    id (^b)(id,id,id,id,id,id,id,id,id) = self.block;
    return b(o1,o2,o3,o4,o5,o6,o7,o8,o9);
}

- (id)_:(id)o1 :(id)o2 :(id)o3 :(id)o4 :(id)o5 :(id)o6 :(id)o7 :(id)o8 :(id)o9 :(id)o10 {
    id (^b)(id,id,id,id,id,id,id,id,id,id) = self.block;
    return b(o1,o2,o3,o4,o5,o6,o7,o8,o9,o10);
}

@end
