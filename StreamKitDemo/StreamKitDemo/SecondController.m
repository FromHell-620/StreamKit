//
//  SecondController.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/30.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SecondController.h"
#import "StreamKit.h"

@interface SecondController ()

@property (nonatomic,strong) NSString* textContent;

@end

@implementation SecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [[[[button sk_signalForControlEvents:UIControlEventTouchUpInside] map:^id(UIButton* x) {
        return x.currentTitle;
    }] filter:^BOOL(id x) {
        return [x isEqualToString:@"点击"];
    }] subscribe:^(id x) {
        NSLog(@"%@",x);
    }];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%@delloc",NSStringFromClass([self class]));
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
