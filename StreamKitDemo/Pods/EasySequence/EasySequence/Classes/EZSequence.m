//
//  EZSequence.m
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import "EZSequence.h"
#import "EZSBlockDefines.h"
#import "EZSTransfer.h"
#import "EZSEnumerator.h"

@interface EZSequence ()

@property (nonatomic, strong) id<NSFastEnumeration> originSequence;

@end

@implementation EZSequence

- (instancetype)initWithOriginSequence:(id<NSFastEnumeration>)originSequence {
    NSParameterAssert(originSequence);
    if (self = [super init]) {
        _originSequence = originSequence;
    }
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer count:(NSUInteger)len {
    return [self.originSequence countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)as:(Class)clazz {
    NSParameterAssert([clazz conformsToProtocol:@protocol(EZSTransfer)]);
    return [clazz transferFromSequence:self];
}

- (NSEnumerator *)objectEnumerator {
    return [[EZSEnumerator alloc] initWithFastEnumerator:self.originSequence];
}

- (void)forEachWithIndexAndStop:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))eachBlock {
    NSParameterAssert(eachBlock);
    if (!eachBlock) { return; }
    NSUInteger index = 0;
    BOOL stop = NO;
    for (id item in self.originSequence) {
        eachBlock(item, index++, &stop);
        if (stop) {
            break;
        }
    }
}

- (BOOL)isEqual:(id)object {
    NSParameterAssert([[object class] conformsToProtocol:@protocol(NSFastEnumeration)]);
    NSEnumerator *selfEnumerator = [self objectEnumerator];
    NSEnumerator *otherEnumerator = [[EZSEnumerator alloc] initWithFastEnumerator:object];
    
    id leftValue = nil;
    id rightValue = nil;
    
    do {
        leftValue = [selfEnumerator nextObject];
        rightValue = [otherEnumerator nextObject];
        
        if (leftValue == rightValue || [leftValue isEqual:rightValue]) {
            continue;
        }
        return NO;
    } while (leftValue != nil);
    return YES;
}

- (NSString *)description {
    return [[self as:NSArray.class] description];
}

@end
