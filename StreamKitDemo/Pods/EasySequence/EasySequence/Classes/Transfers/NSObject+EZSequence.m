//
//  NSObject+EZSequence.m
//  EasySequence
//
//  Created by William Zang on 2018/4/24.
//

#import "NSObject+EZSequence.h"
#import "EZSequence.h"
#import "EZSMetaMacrosPrivate.h"

@implementation NSObject (EZSequence)

- (EZSequence *)EZS_asSequence {
    NSAssert(EZS_idConformsTo(self, NSFastEnumeration), @"%@'s class not conform protocol NSFastEnumeration", self);
    // TODO:THROW_EXCEPTION
    return EZS_Sequence((id<NSFastEnumeration>)self);
}

@end
