//
//  NSOrderedSet+EZSTransfer.m
//  EasySequence
//
//  Created by William Zang on 2018/4/25.
//

#import "NSOrderedSet+EZSTransfer.h"
#import "EZSequence+Operations.h"

@implementation NSOrderedSet (EZSTransfer)

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    return [set copy];
}

@end
