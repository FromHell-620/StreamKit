//
//  UIRefreshControl+SKCommandSupport.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/16.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKCommand;

@interface UIRefreshControl (SKCommandSupport)

@property (nonatomic,strong,setter=set_skCommand:) SKCommand *sk_command;

@end
