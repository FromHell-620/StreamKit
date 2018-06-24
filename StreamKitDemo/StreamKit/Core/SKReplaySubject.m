//
//  SKReplaySubject.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/21.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKReplaySubject.h"
#import "SKValueNil.h"
#import "SKCompoundDisposable.h"
#import "SKScheduler.h"

@interface SKReplaySubject ()

@property (nonatomic,strong) NSMutableArray *valueReceived;

@property (nonatomic,assign) NSInteger capacity;

@property (nonatomic,assign) BOOL hasCompleted;

@property (nonatomic,assign) BOOL hasError;

@property (nonatomic,strong) NSError *error;

@end

@implementation SKReplaySubject

- (instancetype)init {
    return [self initWithCapacity:NSIntegerMax];
}

- (instancetype)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _capacity = capacity;
        _valueReceived = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)subjectWithCapacity:(NSInteger)capacity {
    SKReplaySubject *subject = [[SKReplaySubject alloc] initWithCapacity:capacity];
    return subject;
}

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithBlock:nil];
    SKDisposable *schedulerDisposable = [[SKScheduler subscriptionScheduler] schedule:^{
        @synchronized (self) {
            [self->_valueReceived enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (compoundDisposable.isDisposed) {
                    return ;
                }
                [subscriber sendNext:obj == SKValueNil.ValueNil ? nil : obj];
            }];
            if (self.hasError) {
                [subscriber sendError:self.error];
            }else if (self.hasCompleted) {
                [subscriber sendCompleted];
            }else {
                [compoundDisposable addDisposable:[super subscribe:subscriber]];
            }
        }
    }];
    [compoundDisposable addDisposable:schedulerDisposable];
    return compoundDisposable;
}

- (void)sendNext:(id)value {
    @synchronized (self) {
        [_valueReceived addObject:value ?: SKValueNil.ValueNil];
        if (_valueReceived.count > _capacity) {
            [_valueReceived removeObjectAtIndex:0];
        }
    }
    [super sendNext:value];
}

- (void)sendError:(NSError *)error {
    @synchronized (self) {
        _hasError = YES;
        _error = error;
    }
    [super sendError:error];
}

- (void)sendCompleted {
    @synchronized (self) {
        _hasCompleted = YES;
    }
    [super sendCompleted];
}


@end
