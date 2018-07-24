//
//  EZSTransfer.h
//  EasySequence
//
//  Created by William Zang on 2018/4/24.
//

#import <Foundation/Foundation.h>

@class EZSequence;

/**
 The EZSTransfer protocol is adopted by class that want to get an object converted from EZSequence.
 */
@protocol EZSTransfer <NSObject>

/**
 Converts sequence to the specified object

 @param sequence An sequence object to be converted
 @return An specified object
 */
+ (instancetype)transferFromSequence:(EZSequence *)sequence;

@end
