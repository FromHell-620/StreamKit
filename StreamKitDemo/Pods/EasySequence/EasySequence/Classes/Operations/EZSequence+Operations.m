//
//  EZSequence+Operations.m
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import "EZSequence+Operations.h"
#import "EZSBlockDefines.h"
#import "EZSUsefulBlocks.h"
#import "EZSEnumerator.h"
#import "EZSMetaMacrosPrivate.h"

NSString * const EZSequenceExceptionName = @"EZSequenceExceptionName";
NSString * const EZSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation =
@"EZSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation";

NSString * const EZSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration =
@"EZSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration";


@implementation EZSequence (Operations)

- (void)forEachWithIndex:(void (^)(id _Nonnull, NSUInteger))eachBlock {
    NSParameterAssert(eachBlock);
    if (!eachBlock) { return; }
    void (^block)(id _Nonnull, NSUInteger, BOOL * _Nonnull) = ^(id item, NSUInteger index, BOOL * _) {
        eachBlock(item, index);
    };
    [self forEachWithIndexAndStop:block];
}

- (void)forEach:(void (^)(id _Nonnull))eachBlock {
    NSParameterAssert(eachBlock);
    if (!eachBlock) { return; }
    void (^block)(id _Nonnull, NSUInteger, BOOL * _Nonnull) = ^(id item, NSUInteger index, BOOL * _) {
        eachBlock(item);
    };
    [self forEachWithIndexAndStop:block];
}

- (EZSequence *)flattenMap:(EZSFlattenMapBlock)flattenBlock {
    NSParameterAssert(flattenBlock);
    NSMutableArray *array = [NSMutableArray new];
    for (id item in self) {
        if (flattenBlock) {
            id<NSFastEnumeration> sequence = flattenBlock(item);
            if (!EZS_idConformsTo(sequence, NSFastEnumeration)) {
               EZS_THROW(EZSequenceExceptionName, EZSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation, nil);
            }
            for (id insideItem in sequence) {
                [array addObject:insideItem];
            }
        }
    };
    return EZS_Sequence(array);
}

- (EZSequence *)flatten {
    NSMutableArray *array = [NSMutableArray array];
    [self forEach:^(id  _Nonnull item) {
        if ([item conformsToProtocol:@protocol(NSFastEnumeration)]) {
            for (id innerItem in item) {
                [array addObject:innerItem];
            }
        } else {
            [array addObject:item];
        }
    }];
    return EZS_Sequence(array);
}

- (EZSequence *)concat:(id<NSFastEnumeration>)anotherSequence {
    NSParameterAssert(anotherSequence);
    if (!anotherSequence) { return self; }
    return [EZS_Sequence(@[self, anotherSequence]) flatten];
}

+ (EZSequence *)concatSequences:(id<NSFastEnumeration>)sequences {
    NSParameterAssert(sequences);
    if (!sequences) { return nil; }
    return [EZS_Sequence(sequences) flatten];
}

- (EZSequence *)filter:(EZSFliterBlock)filterBlock {
    NSParameterAssert(filterBlock);
    NSMutableArray *array = [NSMutableArray new];
    for (id item in self) {
        if (filterBlock && filterBlock(item)) {
            [array addObject:item];
        }
    };
    return EZS_Sequence(array);
}

- (EZSequence *)map:(EZSMapBlock)mapBlock {
    NSParameterAssert(mapBlock);
    if (!mapBlock) { return nil; }
    id (^block)(id, NSUInteger) = ^(id item, NSUInteger _) {
        return mapBlock(item);
    };
    return [self mapWithIndex:block];
}

- (EZSequence *)mapWithIndex:(id  _Nonnull (^)(id _Nonnull, NSUInteger))mapBlock {
    NSParameterAssert(mapBlock);
    if (!mapBlock) { return nil;}
    NSMutableArray *array = [NSMutableArray new];
    NSUInteger index = 0;
    for (id item in self) {
        if (mapBlock) {
            [array addObject:mapBlock(item, index++)];
        }
    };
    return EZS_Sequence(array);
}

- (EZSequence *)take:(NSUInteger)count {
    NSParameterAssert(count > 0);
    NSMutableArray *array = [NSMutableArray new];
    [self forEachWithIndexAndStop:^(id  _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
        if (index < count) {
            [array addObject:item];
        } else {
            *stop = YES;
        }
    }];
    return EZS_Sequence(array);
}

- (EZSequence *)skip:(NSUInteger)count {
    NSParameterAssert(count >= 0);
    NSMutableArray *array = [NSMutableArray new];
    [self forEachWithIndexAndStop:^(id  _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
        if (index >= count) {
            [array addObject:item];
        }
    }];
    return EZS_Sequence(array);
}

- (nullable id)firstObject {
    for (id item in self) {
        return item;
    }
    return nil;
}

- (id)firstObjectWhere:(EZSFliterBlock)checkBlock {
    NSParameterAssert(checkBlock);
    if (!checkBlock) { return nil; }
    for (id item in self) {
        if (checkBlock(item)) {
            return item;
        }
    }
    return nil;
}

- (NSUInteger)firstIndexWhere:(EZSFliterBlock)checkBlock {
    NSParameterAssert(checkBlock);
    if (!checkBlock) { return NSNotFound; }
    NSUInteger index = 0;
    for (id item in self) {
        if (checkBlock(item)) {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

- (BOOL)any:(BOOL (^)(id _Nonnull))checkBlock {
    NSParameterAssert(checkBlock);
    if (!checkBlock) { return NO; }
    BOOL result = NO;
    for (id item in self) {
        result = checkBlock(item);
        if (result) {
            return result;
        }
    }
    return result;
}

- (EZSequence *)select:(BOOL (^)(id _Nonnull))selectBlock {
    NSParameterAssert(selectBlock);
    return [self filter:selectBlock];
}

- (EZSequence *)reject:(BOOL (^)(id _Nonnull))rejectBlock {
    NSParameterAssert(rejectBlock);
    if (!rejectBlock) { return nil;}
    return [self select:EZS_not(rejectBlock)];
}

- (id)reduceStart:(id)startValue withBlock:(id  _Nullable (^)(id _Nullable, id _Nullable))reduceBlock {
    NSParameterAssert(reduceBlock);
    if (!reduceBlock) { return nil; }
    id result = startValue;
    for (id value in self) {
        result = reduceBlock(result, value);
    }
    return result;
}

- (id)reduce:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))reduceBlock {
    NSParameterAssert(reduceBlock);
    if (!reduceBlock) { return nil; }
    return [[self skip:1] reduceStart:self.firstObject withBlock:reduceBlock];
}

- (NSDictionary<id<NSCopying>, id> *)groupBy:(id<NSCopying>  _Nonnull (^)(id _Nonnull))groupBlock {
    NSParameterAssert(groupBlock);
    if (!groupBlock) { return nil; }
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    for (id value in self) {
        id key = groupBlock(value);
        NSAssert(key, @"key is nil");
        if (!mutableDic[key]) {
            mutableDic[key] = [NSMutableArray new];
        }
        [mutableDic[key] addObject:value];
    }
    
    for (id key in mutableDic.allKeys) {
        NSMutableArray *items = mutableDic[key];
        mutableDic[key] = EZS_Sequence(items);
    }
    return [mutableDic copy];
}

+ (EZSequence<EZSequence *> *)zipSequences:(id<NSFastEnumeration>)zippedEnumeration {
    NSParameterAssert(zippedEnumeration);
    if (!zippedEnumeration) { return nil; }
    NSMutableArray<EZSequence *> *result = [NSMutableArray new];
    EZSequence<EZSEnumerator *> *sequences = [EZS_SequenceWithType(id<NSFastEnumeration>, zippedEnumeration) map:^id _Nonnull(id<NSFastEnumeration>  _Nonnull item) {
        if (!EZS_idConformsTo(item, NSFastEnumeration)) {
            EZS_THROW(EZSequenceExceptionName, EZSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration, nil);
        }
        return EZS_SequenceWithType(EZSequence *, item).objectEnumerator;
    }];

    
    NSObject *endMarker = NSObject.new;
    for (;;) {
        EZSequence *values = [sequences map:^id _Nonnull(EZSEnumerator * _Nonnull item) {
            __block id next = [item nextObject];
            return next ?: endMarker;
        }];
        if ([values any:EZS_isEqual(endMarker)]) {
            break;
        }
        [result addObject:values];
    }
    return EZS_SequenceWithType(EZSequence *, result);
}

- (EZSequence<EZSequence *> *)zip:(id<NSFastEnumeration>)anotherSequence {
    NSParameterAssert(anotherSequence);
    if (!anotherSequence) { return nil; }
    return [EZSequence zipSequences:@[self, anotherSequence]];
}

@end
