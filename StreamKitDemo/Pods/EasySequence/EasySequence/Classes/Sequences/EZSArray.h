//
//  EZSArray.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>
#import <EasySequence/EZSTransfer.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZSArray<__covariant T> : NSObject <NSFastEnumeration, NSCopying, EZSTransfer>

// The number of objects in the array.
@property (readonly) NSUInteger count;

- (instancetype)initWithNSArray:(NSArray<T> *)array NS_DESIGNATED_INITIALIZER;

// Returns the object located at the specified index.
- (nullable T)objectAtIndex:(NSUInteger)index;

/**
 Inserts a given object at the end of the array.

 @param anObject The object to add to the end of the array’s content. This value must not be `nil`.
 */
- (void)addObject:(T)anObject;

/**
 Inserts a given object into the array’s contents at a given index.

 @param anObject The object to add to the array's content. This value must not be `nil`.
 @param index The index in the array at which to insert `anObject`. This value must not be greater than the count of elements in the array.
 */
- (void)insertObject:(T)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeFirstObject;
- (void)removeObject:(T)anObject;
- (void)removeAllObjects;
/**
 Removes the object at index .

 @param index The index from which to remove the object in the array. The value must not exceed the bounds of the array.
 */
- (void)removeObjectAtIndex:(NSUInteger)index;

/**
 Replaces the object at `index` with `anObject`.

 @param index The index of the object to be replaced. This value must not exceed the bounds of the array.
 @param anObject The object with which to replace the object at index index in the array. This value must not be nil.
 */
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(T)anObject;

- (nonnull NSArray<T> *)toArray;

/**
 Replaces the object at the index with the new object, possibly adding the object.

 @param obj The object with which to replace the object at index index in the array. This value must not be `nil`.
 @param idx The index of the object to be replaced. This value must not exceed the bounds of the array.
 */
- (void)setObject:(T)obj atIndexedSubscript:(NSUInteger)idx;

/**
 Returns the object at the specified index.

 @param index An index within the bounds of the array.
 @return The object located at `index`.
 */
- (T)objectAtIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
