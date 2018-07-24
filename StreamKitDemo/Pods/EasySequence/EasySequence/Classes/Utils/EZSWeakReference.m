//
//  EZSWeakReference.m
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import "EZSWeakReference.h"
#import "EZSBlockDefines.h"
#import "NSObject+EZSDeallocBell.h"

@interface EZSWeakReference () {
    NSUInteger _referenceHash;
}

@property (nonatomic, readonly, copy) EZSApplyBlock block;

@end

@implementation EZSWeakReference

- (instancetype)initWithReference:(NSObject *)reference deallocBlock:(void (^_Nullable)(EZSWeakReference * _Nonnull reference))deallocBlock {
    if (self = [super init]) {
        _reference = reference;
        _referenceHash = reference.hash;
        _block = [deallocBlock copy];
        if (_block) {
            __weak EZSApplyBlock weakDeallocBlock = _block;
            [reference addDeallocCallback:^{
                EZSApplyBlock strongDeallocBlock = weakDeallocBlock;            
                if (strongDeallocBlock) {
                    strongDeallocBlock(self);
                }
            }];
        }
    }
    return self;
}

+ (instancetype)reference:(nonnull id)reference {
    return [[self alloc] initWithReference:reference deallocBlock:nil];
}

- (NSUInteger)hash {
    return _referenceHash;
}

- (BOOL)isEqual:(EZSWeakReference *)object {
    if ([object isKindOfClass:[self class]]) {
        return [self.reference isEqual:object.reference];
    } else {
        return [self.reference isEqual:object];
    }
}

- (NSString *)description {
    return _reference ? [_reference description] : [super description];
}

@end
