//
//  EZSWeakReference.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZSWeakReference<T> : NSObject

@property (nonatomic, readonly, weak) T reference;

+ (instancetype)reference:(nonnull T)reference;
- (instancetype)initWithReference:(nonnull T)reference deallocBlock:(void (^_Nullable)(EZSWeakReference * _Nonnull reference))deallocBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
