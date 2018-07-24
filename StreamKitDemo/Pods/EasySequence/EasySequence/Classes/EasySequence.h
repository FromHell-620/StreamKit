#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import <EasySequence/EZSBlockDefines.h>
#import <EasySequence/EZSequence.h>
#import <EasySequence/EZSequence+Operations.h>
// Sequences
#import <EasySequence/EZSArray.h>
#import <EasySequence/EZSWeakArray.h>
#import <EasySequence/EZSOrderedSet.h>
#import <EasySequence/EZSWeakOrderedSet.h>
#import <EasySequence/EZSQueue.h>

// UserfulBlocks
#import <EasySequence/EZSUsefulBlocks.h>

#import <EasySequence/EZSTransfer.h>
// Enumerators
#import <EasySequence/EZSEnumerator.h>
// Transfers
#import <EasySequence/NSArray+EZSTransfer.h>
#import <EasySequence/NSObject+EZSequence.h>
#import <EasySequence/NSSet+EZSTransfer.h>
#import <EasySequence/NSOrderedSet+EZSTransfer.h>

// Utils
#import <EasySequence/EZSWeakReference.h>
#import <EasySequence/NSObject+EZSDeallocBell.h>

FOUNDATION_EXPORT double EasySequenceVersionNumber;
FOUNDATION_EXPORT const unsigned char EasySequenceVersionString[];

