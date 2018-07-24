//
//  EZSequence+Operations.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <EasySequence/EZSequence.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * const EZSequenceExceptionName;
FOUNDATION_EXTERN NSString * const EZSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation;
FOUNDATION_EXTERN NSString * const EZSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration;

/**
 EZSequence's operations
 */
@interface EZSequence<T> (Operations)

/**
 Executes a given block using each object in the sequence
 
 @param eachBlock The block to apply to elements in the sequence.
 The block takes two arguments:
 - item: The object
 - index: The index of the object in the sequence.
 */
- (void)forEachWithIndex:(void (NS_NOESCAPE ^)(T item, NSUInteger index))eachBlock;

/**
 Executes a given block using each object in the sequence
 
 @param eachBlock The block to apply to elements in the sequence.
 The block takes one argument:
 - item: The object.
 */
- (void)forEach:(void (NS_NOESCAPE ^)(T item))eachBlock;

/**
 Returns a new sequence that is a one-dimensional flattening of self (recursively).
 
 @return A new EZSequence object
 */
- (EZSequence *)flatten;

/**
 Returns a new sequence with the concatenated results of running flattenBlock once for every element in self.

 @param flattenBlock The block to apply to elements in the sequence.
 @return A new EZSequence object
 */
- (EZSequence *)flattenMap:(id<NSFastEnumeration> (NS_NOESCAPE ^)(T item))flattenBlock;

/**
 Appends the elements of anotherSequence to self.

 @param anotherSequence another sequece to be appened
 @return A new EZSequenced object
 */
- (EZSequence *)concat:(id<NSFastEnumeration>)anotherSequence;

/**
 Appends sequences in argument to a new sequence

 @param sequences An argument contains sequences
 @return A new EZSequenced object
 */
+ (EZSequence *)concatSequences:(id<NSFastEnumeration>)sequences;

/**
 Returns a new sequence containing all elements of self for which the given block returns a true value.
 
 @param filterBlock A block to filter elements
 @return A new sequence object
 */
- (EZSequence<T> *)filter:(BOOL (NS_NOESCAPE ^)(T item))filterBlock;

/**
 Invokes the mapBlock once for each element of self. Creates a new sequence containing the values returned by the mapBlock.

 @param mapBlock A block to map element，
 The block takes one argument:
    - item: The object
 
 @return A new sequence object
 */
- (EZSequence *)map:(id (NS_NOESCAPE ^)(T item))mapBlock;

/**
 Invokes the mapBlock once for each element of self. Creates a new sequence containing the values returned by the mapBlock.

 @param mapBlock a block to map element，
 The block takes two arguments:
    - item: The object
    - index: The index of the object in the sequence
 
 @return A new sequence object
 */
- (EZSequence *)mapWithIndex:(id (NS_NOESCAPE ^)(T item, NSUInteger index))mapBlock;

/**
 Returns first n (n = count) elements of self.

 @param count Count of elements want to take
 @return A new sequence object
 */
- (EZSequence<T> *)take:(NSUInteger)count;

/**
 Returns a new sequence contains elements of self from n (n = count) to the end

 @param count Count of elements want to skip
 @return A new sequence
 */
- (EZSequence<T> *)skip:(NSUInteger)count;

/**
 Returns the first element of self, or nil, if self is empty

 @return The first element
 */
- (nullable T)firstObject;

/**
 Returns the first element of self that satisfies the given block. or nil if there is no element that satisfies block.
 
 @param checkBlock A block to check element
 @return The first element match the checkBlock
 */
- (nullable id)firstObjectWhere:(BOOL (NS_NOESCAPE ^)(T item))checkBlock;

/**
 Return the index of the first element of self that satisfies the given block. or nil if there is no element that satisfies block.
 
 @param checkBlock A block to check element
 @return The Index of the first element matched checkBlokc
 */
- (NSUInteger)firstIndexWhere:(BOOL (NS_NOESCAPE ^)(T item))checkBlock;

/**
 Passes each element of self to the given block. The checkBlock returns true if the block ever returns a value other than false or nil

 @param checkBlock A block to check element
 @return A bool value
 */
- (BOOL)any:(BOOL (NS_NOESCAPE ^)(T item))checkBlock;

/**
 Returns a new sequence containing all elements of self for which the given block returns a true value.

 @param selectBlock A block to select element。
 @return A new sequence object
 */
- (EZSequence<T> *)select:(BOOL (NS_NOESCAPE ^)(T item))selectBlock;

/**
 Returns a new sequence containing the elements in self for which the given block is not true

 @param rejectBlock A block to reject element
 @return A new sequence object
 */
- (EZSequence<T> *)reject:(BOOL (NS_NOESCAPE ^)(T item))rejectBlock;

/**
 Returns the result of combining the elements of the sequence using the given block.
 
 @param startValue The value to use as the initial accumulating value. startValue is passed to reduceBlock the first time the block is executed
 @param reduceBlock A block that combines an accumulating value and an element of the sequence into a new accumulating value, to be used in the next call of the reduceBlock or returned to the caller.
 @return The final accumulated value. If the sequence has no elements, the result is startValue.
 */
- (id)reduceStart:(nullable id)startValue withBlock:(id _Nullable(NS_NOESCAPE ^)(id _Nullable accumulator, T _Nullable item))reduceBlock;

/**
 Returns the result of combining the elements of the sequence using the given block.
 
 @param reduceBlock A block that combines an accumulating value and an element of the sequence into a new accumulating value, to be used in the next call of the reduceBlock or returned to the caller.
 @return The final accumulated value. If the sequence has no elements, the result is nil.
 */
- (id)reduce:(id (NS_NOESCAPE ^)(id accumulator, T item))reduceBlock;

/**
 Converts sequences in arguments to one sequence, then merges elements of sequence with corresponding elements from another sequence.
 This generates a sequence of x y-elements sequences. which x takes the lowest count of elements in all sequences and y is the count of sequences

 @param sequences An arguments contain sequences
 @return A new sequence object
 */
+ (EZSequence<EZSequence *> *)zipSequences:(id<NSFastEnumeration>)sequences;

/**
 Converts another sequence to one sequence, then merges elements of self with corresponding elements from another sequence.
 This generates a sequence of x two-elements sequences. which x takes a smaller value between self.count and sequence.count
 
 @param anotherSequence another sequence to be zip
 @return A new sequence object
 */
- (EZSequence<EZSequence *> *)zip:(id<NSFastEnumeration>)anotherSequence;

/**
 Groups the array by the result of the block. Returns an empty dictionary if the original array is empty.
 
 @param groupBlock The block applyed to each item of the original array, the return value will be used as the key of the result dictionary.
 @return A dictionary where the keys are the returned values of the block, and the values are arrays of objects in the original array that correspond to the key.
 */
- (NSDictionary<id<NSCopying>, EZSequence<T> *> *)groupBy:(id<NSCopying> (NS_NOESCAPE ^)(T value))groupBlock;

@end

NS_ASSUME_NONNULL_END
