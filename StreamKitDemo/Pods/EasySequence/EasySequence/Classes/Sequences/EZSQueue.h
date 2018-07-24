//
//  EZSQueue.h
//  EasySequence
//
//  Created by nero on 2018/5/2.
//

#import <Foundation/Foundation.h>
#import <EasySequence/EZSTransfer.h>

@interface EZSQueue<__covariant T> : NSObject <EZSTransfer, NSCopying>

@property (atomic, readonly, assign, getter=isEmpty) BOOL empty;
@property (atomic, readonly, assign) NSUInteger count;
@property (atomic, readonly, strong) T front;

- (void)enqueue:(T)item;
- (T)dequeue;
- (BOOL)contains:(T)item;

@end
