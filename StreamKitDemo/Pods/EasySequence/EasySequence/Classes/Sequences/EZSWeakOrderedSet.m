//
//  EZSWeakOrderedSet.m
//  EasySequence
//
//  Created by nero on 2018/4/27.
//

#import "EZSWeakOrderedSet.h"
#import "EZSWeakReference.h"
#import "EZSequence+Operations.h"
#import "EZSUsefulBlocks.h"

@implementation EZSWeakOrderedSet

- (instancetype)initWithNSOrderedSet:(NSOrderedSet *)set {
    NSParameterAssert(set);
    if (self = [super initWithNSOrderedSet:[NSOrderedSet orderedSet]]) {
        for (id item in set) {
            [self addObject:item];
        }
    }
    return self;
}

- (NSArray *)allObjects {
    NSMutableArray *array = [NSMutableArray array];
    for (EZSWeakReference *reference in [super allObjects]) {
        id strongItem = reference.reference;
        if (strongItem) {
            [array addObject:strongItem];
        }
    }
    return array;
}

- (EZSWeakReference *)weakReference:(id _Nonnull)anObject {
    __weak typeof(self) weakSelf = self;
    return [[EZSWeakReference alloc] initWithReference:anObject deallocBlock:^(EZSWeakReference * _Nonnull ref) {
        __strong typeof(weakSelf) self = weakSelf;
        [self removeObject:ref];
    }];
}

#pragma mark -  get methods

- (id)objectAtIndex:(NSUInteger)index {
    EZSWeakReference *obj = [super objectAtIndex:index];
    return obj.reference;
}

#pragma mark - add methods

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    EZSWeakReference *obj = [self weakReference:anObject];
    [super insertObject:obj atIndex:index];
}

#pragma mark - replace methods

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)idx {
    EZSWeakReference *obj = [self weakReference:anObject];
    [super setObject:obj atIndexedSubscript:idx];
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    __autoreleasing NSArray *array = self.allObjects;
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id)copyWithZone:(NSZone *)zone {
    EZSWeakOrderedSet *newInstance = [[[self class] allocWithZone:zone] init];
    for (id item in self) {
        [newInstance addObject:item];
    }
    return newInstance;
}

#pragma mark - EZSTransfer Protocol

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    EZSWeakOrderedSet *set = [[EZSWeakOrderedSet alloc] init];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    return set;
}

@end
