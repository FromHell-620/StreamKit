//
//  ViewController.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "SecondController.h"
#import "StreamKit.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()<UITextViewDelegate>

@end

@implementation ViewController {
    SKCommand *_command;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [UILabel new];
    
    label.frame = CGRectMake(30, 100, 200, 40);
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor blueColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 200, 300, 40)];
    textView.backgroundColor = [UIColor redColor];
    textView.delegate = self;
    [self.view addSubview:textView];
//
    
    [[label.sk_clickSignal throttle:2] subscribeNext:^(id x) {
        NSLog(@"aaa");
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 300, 60, 60);
    [self.view addSubview:btn];
    
    SKSelector(self.navigationController, pushViewController:animated:) = [btn.sk_clickSignal map:^id(id x) {
        return @[SecondController.new,@YES];
    }];
    
    SKSelector(label, setText:) = textView.sk_textSignal;
    
    
}

//- (void)textViewDidChange:(UITextView *)textView {
//    om
//}


- (void)btnAction {
    SecondController *vc = [SecondController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
