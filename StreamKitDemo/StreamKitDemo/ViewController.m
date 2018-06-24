//
//  ViewController.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "SecondController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()<UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 200, 300, 40)];
    textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:textView];
//
    [[textView rac_textSignal] subscribeNext:^(id x) {

    }];
    
    // Do any additional setup after loading the view.
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

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
