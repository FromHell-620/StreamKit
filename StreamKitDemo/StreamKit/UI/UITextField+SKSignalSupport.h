//
//  UITextField+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSignal.h"

@interface UITextField (SKSignalSupport)

- (SKSignal<NSString *> *)sk_textSignal;

@end
