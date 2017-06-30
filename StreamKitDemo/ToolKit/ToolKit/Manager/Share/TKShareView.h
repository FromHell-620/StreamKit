//
//  TKShareView.h
//  ToolKit
//
//  Created by chunhui on 15/5/26.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKShareManager.h"

@interface TKShareView : UIView

@property(nonatomic , copy)void((^shareTo)(TKSharePlatform platform));

+(TKShareView *)DefaultShareView;
-(void)showInView:(UIView *)view;
-(void)dismiss;

@end