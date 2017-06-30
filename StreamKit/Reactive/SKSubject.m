//
//  SKSubject.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/6/30.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubject.h"
#import "SKSubscriber.h"

@interface SKSubject ()

@property (nonatomic,strong) NSMutableArray<id<SKSubscriber>> *subscribers;

@end

@implementation SKSubject

+ (instancetype)subject {
    SKSubject *subject = [SKSubject new];
    subject.subscribers = [NSMutableArray array];
    return subject;
}

- (void)subscribe:(id<SKSubscriber>)subscriber {
    NSParameterAssert(subscriber);
    @synchronized (self) {
        [self.subscribers addObject:subscriber];
    }
}

- (void)enumerSubscriber:(void(^)(id<SKSubscriber> subscriber))block {
    [self.subscribers enumerateObjectsUsingBlock:^(id<SKSubscriber>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)sendNext:(id)value {
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendNext:value];
    }];
}

- (void)sendError:(NSError*)error {
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendError:error];
    }];
}

- (id)sendNextWithReturnValue:(id)value {
    return nil;
}

- (void)sendComplete:(id)value {
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendComplete:value];
    }];
}

- (id)sendCompleteWithReturnValue:(id)value {
    return nil;
}

@end
