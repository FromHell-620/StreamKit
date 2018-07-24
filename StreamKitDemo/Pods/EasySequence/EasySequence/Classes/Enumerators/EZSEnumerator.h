//
//  EZSEnumerator.h
//  EasySequence
//
//  Created by nero on 2018/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 `EZSEnumerator` is an enumerator object that lets you access each object in the sequence
 */
@interface EZSEnumerator : NSEnumerator

/**
 Initializes and returns a newly allocated enumerator object with the specified object implented the `NSFastEnumeration` protocol.

 @param fastEnumerator An object that implements the `NSFastEnumeration` protocol
 @return An initialized EZSEnumerator object
 */
- (instancetype)initWithFastEnumerator:(id<NSFastEnumeration>)fastEnumerator NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
