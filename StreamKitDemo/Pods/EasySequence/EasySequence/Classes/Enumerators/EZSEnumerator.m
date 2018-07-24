//
//  EZSEnumerator.m
//  EasySequence
//
//  Created by nero on 2018/4/28.
//

#import "EZSEnumerator.h"

#define EZS_COMPARE_SIZE    16

@implementation EZSEnumerator {
    NSUInteger _nextIndex;
    id<NSFastEnumeration> _fastEnumerator;
    NSFastEnumerationState _fastEnumeratorState;
    __unsafe_unretained id _buffer[EZS_COMPARE_SIZE];
    NSUInteger _lastCount;
    BOOL _fastEnumeratorFinished;
}

- (instancetype)initWithFastEnumerator:(id<NSFastEnumeration>)fastEnumerator {
    NSParameterAssert(fastEnumerator);
    if (self = [super init]) {
        _nextIndex = 0;
        _fastEnumerator = fastEnumerator;
        _lastCount = 0;
    }
    return self;
}

- (id)nextObject {
    if (_nextIndex >= _lastCount) {
        _lastCount = [_fastEnumerator countByEnumeratingWithState:&_fastEnumeratorState objects:_buffer count:EZS_COMPARE_SIZE];
        _nextIndex = 0;
    }
    if (_lastCount == 0) { return nil; }
    return _fastEnumeratorState.itemsPtr[_nextIndex++];
}

@end

#undef EZS_COMPARE_SIZE
