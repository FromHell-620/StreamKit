//
//  CSEmailLoginViewController.h
//  CaiLianShe
//
//  Created by 李津通 on 15/12/11.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKLoginWithEmailView.h"

@interface TKEmailLoginViewController : UIViewController

@property (nonatomic, strong)TKLoginWithEmailView *loginWithEmailView;

//点击登录
- (void)clickLogin:(NSString *)email passWord:(NSString *)passWord;

@end
