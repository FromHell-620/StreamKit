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


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSString* textContent;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
    [[button sk_eventSignal] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"111" object:nil];
    }];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button1.frame = CGRectMake(100, 300, 100, 100);
    [button1.sk_eventSignal subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"222" object:nil];
        
    }];
    [self.view addSubview:button1];
    
    [[[NSNotificationCenter defaultCenter] sk_signalWithName:@"111" observer:self] subscribeNext:^(NSNotification* x) {
        NSLog(@"x1 = %@",x.name);
    }];
    [[[NSNotificationCenter defaultCenter] sk_signalWithName:@"222" observer:self] subscribeNext:^(NSNotification *x) {
        NSLog(@"x2 == %@",x.name);
    }];
    //    SK(label,text) = SKObserve(self, textContent);
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
