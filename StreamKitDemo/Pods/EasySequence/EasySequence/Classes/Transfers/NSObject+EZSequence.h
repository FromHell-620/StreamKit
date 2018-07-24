//
//  NSObject+EZSequence.h
//  EasySequence
//
//  Created by William Zang on 2018/4/24.
//

#import <Foundation/Foundation.h>

@class EZSequence;

@interface NSObject (EZSequence)

/**
 Get An EZSequence object. Needs to implement `NSFastEnumeration` protocol first

 @return An initialized EZSequence object
 */
- (EZSequence *)EZS_asSequence;

@end
