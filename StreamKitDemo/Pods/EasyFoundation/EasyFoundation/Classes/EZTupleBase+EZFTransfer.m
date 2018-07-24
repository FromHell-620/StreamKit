//
//  EZTupleBase+EZFTransfer.m
//  EasyReact
//
//  Created by nero on 2018/5/10.
//

#import "EZTupleBase+EZFTransfer.h"
#import <EasySequence/EasySequence.h>

@implementation EZTupleBase (EZFTransfer)

+ (instancetype)transferFromSequence:(EZSequence *)sequence {
    return [EZTupleBase tupleWithArray:[sequence as:NSArray.class]];
}

@end
