//
//  EZSBlockDefines.h
//  EasySequence
//
//  Created by William Zang on 2018/4/20.
//

#import <Foundation/Foundation.h>

typedef void (^EZSVoidBlock)(void);
typedef void (^EZSForEachBlock)(id value);
typedef EZSForEachBlock EZSApplyBlock;
typedef id (^EZSMapBlock)(id value);
typedef BOOL (^EZSFliterBlock)(id value);
typedef id<NSFastEnumeration> (^EZSFlattenMapBlock)(id value);
