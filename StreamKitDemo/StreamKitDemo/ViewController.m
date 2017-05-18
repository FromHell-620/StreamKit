//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "StreamKit.h"
#import "SecondController.h"
@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSString* textContent;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
    [[button sk_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[SecondController new] animated:YES];
    }];
    [self.view addSubview:button];
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
