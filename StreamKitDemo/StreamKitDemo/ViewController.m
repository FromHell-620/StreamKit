//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "StreamContentController.h"
#import <StreamKit/StreamKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.sk_frame(CGRectMake(100, 100, 100, 100))
    .sk_setTitleNormal(@"lihao").sk_setTitleColorNormal([UIColor redColor])
    .sk_setFontSize(15)
    .sk_addEventBlock(UIControlEventTouchDown,^(UIButton* button){
        
    }).sk_addEventBlock(UIControlEventTouchUpInside,^(UIButton* button){
        
    });
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
