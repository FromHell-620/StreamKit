//
//  EZSequence.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>

@protocol EZSTransfer;

NS_ASSUME_NONNULL_BEGIN

@interface EZSequence<T> : NSObject <NSFastEnumeration>

/**
 Initializes and returns a newly allocated sequence object with the specified object implented the `NSFastEnumeration` protocol.

 @param originSequence An object that implements the `NSFastEnumeration` protocol
 @return An initialized EZSequence object
 */
- (instancetype)initWithOriginSequence:(id<NSFastEnumeration>)originSequence NS_DESIGNATED_INITIALIZER;

/**
 Converts EZSequence to the specified object implented the `EZSTransfer` protocol
  
 @param clazz An object that implements the `EZSTransfer` protocol
 @return An initialized EZSequence object 
 */
- (id)as:(Class<EZSTransfer>)clazz;

/**
 Executes a given block using each object in the sequence, starting with the first object and continuing through the sequence to the last object.
 
 @param eachBlock The block to execute for each object in the sequence. The block takes three arguments:：
 - item: The object.
 - index: The index of the object in the sequence.
 - stop: A reference to a Boolean value. Setting the value to YES within the block stops further enumeration of the sequence. If a block stops further enumeration, that block continues to run until it’s finished.
 */
- (void)forEachWithIndexAndStop:(void (NS_NOESCAPE ^)(T item, NSUInteger index, BOOL *stop))eachBlock;

/**
 Returns an enumerator object that lets you access each object in the sequence.

 @return An enumerator object that lets you access each object in the sequence, in order, from the element at the lowest index upwards.
 */
- (NSEnumerator<T> *)objectEnumerator;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#define EZS_Sequence(...)                        [[EZSequence alloc] initWithOriginSequence:__VA_ARGS__]
#define EZS_SequenceWithType(__type__, ...)      ((EZSequence<__type__> *)EZS_Sequence(__VA_ARGS__))

