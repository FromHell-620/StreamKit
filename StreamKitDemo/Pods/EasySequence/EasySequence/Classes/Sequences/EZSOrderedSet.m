//
//  EZSOrderedSet.m
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import "EZSOrderedSet.h"
#import "EZSequence+Operations.h"
#import "EZSMetaMacrosPrivate.h"
#import "EZSUsefulBlocks.h"

@implementation EZSOrderedSet {
    NSMutableOrderedSet *_orderedSet;
    EZS_LOCK_DEF(_orderedSetLock);
}

#pragma mark - init

- (instancetype)init {
    if (self = [self initWithNSOrderedSet:[NSOrderedSet orderedSet]]) {
        
    }
    return self;
}

- (instancetype)initWithNSArray:(NSArray *)array {
    NSParameterAssert(array);
    NSOrderedSet *set = array ? [NSOrderedSet orderedSetWithArray:array] : [NSOrderedSet orderedSet];
    if (self = [self initWithNSOrderedSet:set]) {
        
    }
    return self;
}

- (instancetype)initWithNSOrderedSet:(NSOrderedSet *)set {
    NSParameterAssert(set);
    set = set ?: [NSOrderedSet orderedSet];
    if (self = [super init]) {
        _orderedSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:set];
        EZS_LOCK_INIT(_orderedSetLock);
    }
    return self;
}

- (NSUInteger)count {
    EZS_SCOPELOCK(_orderedSetLock);
    return _orderedSet.count;
}

#pragma mark -  get methods

- (id)objectAtIndex:(NSUInteger)index {
    EZS_SCOPELOCK(_orderedSetLock);
    return [_orderedSet objectAtIndex:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}

#pragma mark - add methods

- (void)addObject:(id)anObject {
    [self insertObject:anObject atIndex:self.count];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    EZS_SCOPELOCK(_orderedSetLock);
    [_orderedSet insertObject:anObject atIndex:index];
}


#pragma mark - remove methods

- (void)removeLastObject {
    if (self.count >= 1) {
        [self removeObjectAtIndex:(_orderedSet.count - 1)];
    }
}

- (void)removeFirstObject {
    if (self.count > 0){
        [self removeObjectAtIndex:0];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    EZS_SCOPELOCK(_orderedSetLock);
    [_orderedSet removeObjectAtIndex:index];
}

- (void)removeObject:(id)anObject {
    EZS_SCOPELOCK(_orderedSetLock);
    NSUInteger index = [EZS_Sequence(_orderedSet) firstIndexWhere:EZS_isEqual(anObject)];
    if (index != NSNotFound) {
        [_orderedSet removeObjectAtIndex:index];
    }
}

- (void)removeAllObjects {
    EZS_SCOPELOCK(_orderedSetLock);
    [_orderedSet removeAllObjects];
}

#pragma mark - replace methods

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count) {
        [self setObject:anObject atIndexedSubscript:index];
    }
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    EZS_SCOPELOCK(_orderedSetLock);
    [_orderedSet setObject:obj atIndexedSubscript:idx];
}


- (NSArray *)allObjects {
    EZS_SCOPELOCK(_orderedSetLock);
    return _orderedSet.array;
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger)countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer count:(NSUInteger)len {
    __autoreleasing NSOrderedSet *orderedSet = ({
        EZS_SCOPELOCK(_orderedSetLock);
        [_orderedSet copy];
    });
    return [orderedSet countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id)copyWithZone:(NSZone *)zone {
    EZSOrderedSet *newInstance = [[self class] allocWithZone:zone];
    EZS_LOCK_INIT(newInstance->_orderedSetLock);
    {
        EZS_SCOPELOCK(_orderedSetLock);
        newInstance->_orderedSet = [_orderedSet mutableCopy];
    }
    return newInstance;
}

- (BOOL)isEqual:(id)object {
    EZS_SCOPELOCK(_orderedSetLock);
    if ([object isKindOfClass:[NSOrderedSet class]]) {
        return [_orderedSet isEqualToOrderedSet:object];
    } else if ([object isKindOfClass:[self class]]) {
        EZSOrderedSet *anOtherSet = object;
        EZS_SCOPELOCK(anOtherSet->_orderedSetLock);
        return [_orderedSet isEqualToOrderedSet:anOtherSet->_orderedSet];
    } else {
        return NO;
    }
}

#pragma mark - EZSTransfer Protocol

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    return [[EZSOrderedSet alloc] initWithNSOrderedSet:set];
}

- (NSString *)description {
    return [NSString stringWithFormat:@" %@: {%@}", NSStringFromClass([self class]), EZS_Sequence(self)];
}

@end
