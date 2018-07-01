//
//  FHQueueScheduler.h
//  FHSchedulerDemo
//
//  Created by 李浩 on 2017/7/23.
//  Copyright © 2017年 GodL. All rights reserved.
//

#import "SKScheduler.h"

@interface SKQueueScheduler : SKScheduler

@property (nonatomic,strong,readonly) dispatch_queue_t queue;

- (instancetype)initWithQos:(NSQualityOfService)qos;

- (instancetype)initWithQueue:(dispatch_queue_t)queue;

dispatch_qos_class_t FHQueueQosWithQuality(NSQualityOfService qos);

@end
