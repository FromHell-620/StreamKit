//
//  EZSArray.m
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import "EZSArray.h"
#import "EZSequence+Operations.h"
#import "EZSUsefulBlocks.h"
#import "EZSMetaMacrosPrivate.h"

@interface EZSArray () {
    NSMutableArray *_array;
    EZS_LOCK_DEF(_arrayLock);
}

@end

@implementation EZSArray

- (instancetype)init {
    if (self = [self initWithNSArray:@[]]) {
    }
    return self;
}

- (instancetype)initWithNSArray:(NSArray *)array {
    NSParameterAssert(array);
    NSMutableArray *arr = array ? [array mutableCopy] : [NSMutableArray array];
    if (self = [super init]) {
        EZS_LOCK_INIT(_arrayLock);
        _array = arr;
    }
    return self;
}

- (NSUInteger)count {
    EZS_SCOPELOCK(_arrayLock);
    return _array.count;
}

- (nonnull NSArray *)toArray {
    EZS_SCOPELOCK(_arrayLock);
    return [_array copy];
}

#pragma mark -  get methods

- (nullable id)objectAtIndex:(NSUInteger)index {
    EZS_SCOPELOCK(_arrayLock);
    return [_array objectAtIndex:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}

#pragma mark - add methods

- (void)addObject:(id)anObject {
    return [self insertObject:anObject atIndex:self.count];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    EZS_SCOPELOCK(_arrayLock);
    return [_array insertObject:anObject atIndex:index];
}

#pragma mark - remove methods

- (void)removeLastObject {
    if (self.count >= 1) {
        [self removeObjectAtIndex:(self.count - 1)];
    }
}

- (void)removeFirstObject {
    if (self.count > 0){
        [self removeObjectAtIndex:0];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    EZS_SCOPELOCK(_arrayLock);
    [_array removeObjectAtIndex:index];
}

- (void)removeObject:(id)anObject {
    EZS_SCOPELOCK(_arrayLock);
    NSUInteger index = [EZS_Sequence(_array) firstIndexWhere:EZS_isEqual(anObject)];
    if (index != NSNotFound) {
        [_array removeObjectAtIndex:index];
    }
}

- (void)removeAllObjects {
    EZS_SCOPELOCK(_arrayLock);
    [_array removeAllObjects];
}

#pragma mark - replace methods

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count) {
        [self setObject:anObject atIndexedSubscript:index];
    }
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    EZS_SCOPELOCK(_arrayLock);
    [_array setObject:obj atIndexedSubscript:idx];
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger)countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer count:(NSUInteger)len {
    __autoreleasing NSArray *array = ({
        EZS_SCOPELOCK(_arrayLock);
        [_array copy];
    });
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id)copyWithZone:(NSZone *)zone {
    EZSArray *newArray = [[self class] allocWithZone:zone];
    EZS_LOCK_INIT(newArray->_arrayLock);
    EZS_SCOPELOCK(_arrayLock);
    newArray->_array = [_array mutableCopy];
    return newArray;
}

- (BOOL)isEqual:(id)object {
    EZS_SCOPELOCK(_arrayLock);
    if ([object isKindOfClass:[NSArray class]]) {
        return [_array isEqualToArray:object];
    } else if ([object isKindOfClass:[self class]]) {
        EZSArray *rightValue = (EZSArray *)object;
        EZS_SCOPELOCK(rightValue->_arrayLock);
        return [_array isEqualToArray:rightValue->_array];
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" %@: %@", NSStringFromClass([self class]),EZS_Sequence(self)];
}

#pragma mark - EZSTransfer Protocol

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    NSMutableArray *array = [NSMutableArray array];
    [sequence forEach:^(id  _Nonnull item) {
        [array addObject:item];
    }];
    return [[EZSArray alloc] initWithNSArray:array];
}

@end
