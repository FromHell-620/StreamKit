//
//  TKTapCharLabel.h
//  ToolKitDemo
//
//  Created by chunhui on 2016/10/11.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 * 点击label的text 有回调
 */
@interface TKTapCharLabel : UILabel

@property(nonatomic , copy) BOOL (^handleTapCharAtIndex)(NSInteger index);

@end
