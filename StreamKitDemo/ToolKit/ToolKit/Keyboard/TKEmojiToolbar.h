//
//  TKEmojiToolbar.h
//  ToolKit
//
//  Created by chunhui on 16/4/20.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKEmojiToolbar : UIView

@property(nonatomic , copy) void(^chooseAtIndex)(NSInteger index);
@property(nonatomic , copy) void(^sendBlock)();
@property(nonatomic , strong) UIColor *sendBgColor;

-(void)updateWithIcons:(NSArray<UIImage *> *)icons;

@end
