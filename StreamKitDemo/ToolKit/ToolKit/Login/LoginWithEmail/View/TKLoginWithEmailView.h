//
//  TKLoginWithEmailView.h
//  ToolKit
//
//  Created by 奥那 on 16/1/6.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKLoginWithEmailView : UIView

@property (nonatomic, copy)void (^loginWithEmail)(NSString *,NSString *);
@property (nonatomic, strong)UIView *inputView;//输入视图
@property (nonatomic, strong)UITextField *emailField;//邮箱输入框
@property (nonatomic, strong)UITextField *passWordField;//密码输入框
@property (nonatomic, strong)UIView *line2;//分割线
@property (nonatomic, strong)UIButton *confirmBtn;
@end
