//
//  NSObject+EZSDeallocBell.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>
#import <EasySequence/EZSBlockDefines.h>

@interface NSObject (EZSDeallocBell)

- (void)addDeallocCallback:(EZSVoidBlock)block;

@end
