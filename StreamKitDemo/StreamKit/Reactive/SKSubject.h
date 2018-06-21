//
//  SKSubject.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/6/30.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSignal.h"
#import "SKSubscriber.h"

@interface SKSubject : SKSignal<SKSubscriber>

+ (instancetype)subject;

@end
