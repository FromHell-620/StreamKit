//
//  UIButton+SKCommand.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/21.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKCommand;

@interface UIButton (SKCommand)

@property (nonatomic,strong,setter=sk_setCommand:) SKCommand *sk_command;

@end
