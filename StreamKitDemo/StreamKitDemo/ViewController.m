//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "SecondController.h"
#import "StreamKit.h"
#import "Test.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSString* textContent;

@property (nonatomic,strong) SKSignal *signal;





@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
//    [[button sk_eventSignal] subscribeNext:^(id x) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"111" object:nil];
//    }];
//    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button1.frame = CGRectMake(100, 300, 100, 100);
    [button1.sk_eventSignal subscribeNext:^(id x) {
        [self.navigationController pushViewController:[SecondController new] animated:YES];
    }];
    [self.view addSubview:button1];
    dispatch_queue_t queue = dispatch_queue_create("nnn", 0);
    dispatch_async(queue, ^{
        [button class];
    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
