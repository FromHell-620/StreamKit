//
//  CSEmailLoginViewController.m
//  CaiLianShe
//
//  Created by 李津通 on 15/12/11.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import "TKEmailLoginViewController.h"

//邮箱登录页面
@interface TKEmailLoginViewController ()<UITextFieldDelegate>


@end
@implementation TKEmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    [self.view addSubview:self.loginWithEmailView];
    [self customNavigationItem];
}

- (TKLoginWithEmailView *)loginWithEmailView{
    if (!_loginWithEmailView) {
        __weak typeof (self)weakSelf = self;
        
        _loginWithEmailView = [[TKLoginWithEmailView alloc] initWithFrame:self.view.frame];
        _loginWithEmailView.loginWithEmail = ^(NSString *email,NSString *passWord){
            [weakSelf clickLogin:email passWord:passWord];
        };
    }
    return _loginWithEmailView;
}

- (void)customNavigationItem{
    //navigationBar
//    UIBarButtonItem *leftButton = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(clickBack)];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.title = @"邮箱登录";
}

//点击返回
- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击登录
- (void)clickLogin:(NSString *)email passWord:(NSString *)passWord{

}


@end
