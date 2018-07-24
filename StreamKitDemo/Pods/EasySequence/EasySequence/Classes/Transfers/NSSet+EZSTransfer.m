//
//  NSSet+EZSTransfer.m
//  EasySequence
//
//  Created by nero on 2018/5/4.
//

#import "NSSet+EZSTransfer.h"
#import "EZSequence+Operations.h"

@implementation NSSet (EZSTransfer)

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    NSMutableSet *set = [NSMutableSet set];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    return [set copy];
}

@end
