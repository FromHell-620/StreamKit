//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "StreamKit/StreamKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view = UIView.sk_init(CGRectMake(100, 100, 100, 100)).sk_backgroundColor([UIColor redColor]);
    UITapGestureRecognizer* tap = UITapGestureRecognizer.sk_initWithBlock(^(UITapGestureRecognizer* tap){
        NSLog(@"点击了");
    });
    
    UISwipeGestureRecognizer* swipe = UISwipeGestureRecognizer.sk_initWithBlock(^(UISwipeGestureRecognizer* swi) {
        NSLog(@"轻扫了");
    }).sk_direction(UISwipeGestureRecognizerDirectionLeft);
    view.sk_addGestureRecognizer(tap).sk_addGestureRecognizer(swipe);
    [self.view addSubview:view];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
