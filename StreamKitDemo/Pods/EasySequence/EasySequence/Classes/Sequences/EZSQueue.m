//
//  EZSQueue.m
//  EasySequence
//
//  Created by nero on 2018/5/2.
//

#import "EZSQueue.h"
#import "EZSArray.h"
#import "EZSequence+Operations.h"
#import "EZSUsefulBlocks.h"
#import "EZSMetaMacrosPrivate.h"

@interface EZSLinkedList<T> : NSObject <NSCopying>

@property (nonatomic, strong) T value;
@property (nonatomic, strong) EZSLinkedList *next;

- (instancetype)initWithValue:(T)value next:(EZSLinkedList *)next NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithValue:(T)value;
- (instancetype)init;

@end

@implementation EZSLinkedList

- (instancetype)initWithValue:(id)value next:(EZSLinkedList *)next {
    if (self = [super init]) {
        _value = value;
        _next = next;
    }
    return self;
}

- (instancetype)initWithValue:(id)value {
    if (self = [self initWithValue:value next:nil]) {
        
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithValue:nil next:nil]) {
        
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    EZSLinkedList *copiedLinkedList = [EZSLinkedList allocWithZone:zone];
    copiedLinkedList->_value = self.value;
    copiedLinkedList->_next = [self.next copyWithZone:zone];
    return copiedLinkedList;
}

- (BOOL)isEqual:(EZSLinkedList *)another {
    if ([another isKindOfClass:[self class]]) {
        if (self.value == another.value || [self.value isEqual:another.value]) {
            if (self.next == nil && another.next == nil) {
                return YES;
            }
            return [self.next isEqual:another.next];
        }
        return NO;
    }
    return NO;
}

@end

@implementation EZSQueue {
    EZS_LOCK_DEF(_linkedListLock);
    EZSLinkedList *_front;
    EZSLinkedList *_tail;
}
- (instancetype)init {
    if (self = [super init]) {
        EZS_LOCK_INIT(_linkedListLock);
    }
    return self;
}

- (BOOL)isEmpty {
    EZS_SCOPELOCK(_linkedListLock);
    return _front == nil;
}

- (NSUInteger)count {
    EZS_SCOPELOCK(_linkedListLock);
    NSUInteger count = 0;
    EZSLinkedList *list = _front;
    while (list) {
        count++;
        list = list.next;
    }
    return count;
}

- (void)enqueue:(id)item {
    EZS_SCOPELOCK(_linkedListLock);
    EZSLinkedList *list = [[EZSLinkedList alloc] initWithValue:item];
    if (_tail) {
        _tail.next = list;
    }
    _tail = list;
    if (_front == nil) {
        _front = list;
    }
}

- (id)dequeue {
    EZS_SCOPELOCK(_linkedListLock);
    id value = _front.value;
    _front = _front.next;
    if (_front == nil) {
        _tail = nil;
    }
    return value;
}

- (id)front {
    EZS_SCOPELOCK(_linkedListLock);
    return _front.value;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    EZSQueue *newQuque = [EZSQueue allocWithZone:zone];
    EZS_LOCK_INIT(newQuque->_linkedListLock);
    EZS_SCOPELOCK(_linkedListLock);
    newQuque->_front = [_front copyWithZone:zone];
    EZSLinkedList *list = newQuque->_front;
    EZSLinkedList *tail = nil;
    while (list) {
        tail = list;
        list = list.next;
    }
    newQuque->_tail = tail;
    return newQuque;
}

- (BOOL)isEqual:(EZSQueue *)object {
    EZS_SCOPELOCK(_linkedListLock);
    EZS_SCOPELOCK(object->_linkedListLock);
    return [_front isEqual:object->_front];
}

- (BOOL)contains:(id)item {
    EZS_SCOPELOCK(_linkedListLock);
    EZSLinkedList *list = _front;
    while (list) {
        if (list.value == item) {
            return YES;
        }
        list = list.next;
    }
    return NO;
}

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    EZSQueue *queue = [[EZSQueue alloc] init];
    [sequence forEach:^(id  _Nonnull item) {
        [queue enqueue:item];
    }];
    return queue;
}

@end
