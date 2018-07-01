//
//  FHSerialQueueScheduler.m
//  FHSchedulerDemo
//
//  Created by 李浩 on 2017/7/23.
//  Copyright © 2017年 GodL. All rights reserved.
//

#import "SKSerialQueueScheduler.h"

@implementation SKSerialQueueScheduler

- (instancetype)initWithQos:(NSQualityOfService)qos {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, FHQueueQosWithQuality(qos), 0);
    return [super initWithQueue:dispatch_queue_create("org.SKScheduler.serialQueueScheduler", attr)];
}

@end
