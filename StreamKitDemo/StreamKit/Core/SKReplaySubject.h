//
//  SKReplaySubject.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/21.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSubject.h"

@interface SKReplaySubject : SKSubject

+ (instancetype)subjectWithCapacity:(NSInteger)capacity;

@end
