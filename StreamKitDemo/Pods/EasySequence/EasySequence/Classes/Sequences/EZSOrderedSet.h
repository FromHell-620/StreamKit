//
//  EZSOrderedSet.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>
#import <EasySequence/EZSTransfer.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZSOrderedSet<__covariant T> : NSObject <NSFastEnumeration, NSCopying, EZSTransfer>

@property (readonly) NSUInteger count;

- (instancetype)initWithNSArray:(NSArray<T> *)array;
- (instancetype)initWithNSOrderedSet:(NSOrderedSet<T> *)set NS_DESIGNATED_INITIALIZER;

- (T)objectAtIndex:(NSUInteger)index;
- (void)addObject:(T)anObject;
- (void)insertObject:(T)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeFirstObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeObject:(T)anObject;
- (void)removeAllObjects;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(T)anObject;

- (NSArray<T> *)allObjects;

- (void)setObject:(T)obj atIndexedSubscript:(NSUInteger)idx;
- (T)objectAtIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
