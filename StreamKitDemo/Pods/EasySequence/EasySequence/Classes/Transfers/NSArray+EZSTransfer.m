//
//  NSArray+EZSTransfer.m
//  EasySequence
//
//  Created by William Zang on 2018/4/24.
//

#import "NSArray+EZSTransfer.h"
#import "EZSequence+Operations.h"

@implementation NSArray (EZSTransfer)

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    NSMutableArray *array = [NSMutableArray array];
    [sequence forEach:^(id  _Nonnull item) {
        [array addObject:item];
    }];
    return [array copy];
}

@end
