//
//  EZSWeakArray.m
//  EasySequence
//
//  Created by nero on 2018/4/27.
//

#import "EZSWeakArray.h"
#import "EZSWeakReference.h"
#import "EZSequence+Operations.h"
#import "EZSUsefulBlocks.h"

@implementation EZSWeakArray

- (instancetype)initWithNSArray:(NSArray *)array {
    NSParameterAssert(array);
    if (self = [super initWithNSArray:@[]]) {
        for (id item in array) {
            [self addObject:item];
        }
    }
    return self;
}

#pragma mark -  get methods

- (nullable id)objectAtIndex:(NSUInteger)index {
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

#pragma mark - fastEnumeation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    __autoreleasing NSArray *array = self.toArray;
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id)copyWithZone:(NSZone *)zone {
    EZSWeakArray *newArray = [[[self class] allocWithZone:zone] init];
    for (id item in self) {
        [newArray addObject:item];
    }
    return newArray;
}

#pragma mark - EZSTransfer Protocol

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    EZSWeakArray *array = [[EZSWeakArray alloc] init];
    [sequence forEach:^(id  _Nonnull item) {
        [array addObject:item];
    }];
    return array;
}

- (NSArray *)toArray {
    NSMutableArray *array = [NSMutableArray array];
    for (EZSWeakReference *reference in [super toArray]) {
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

@end
