//
//  SecondController.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/30.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SecondController.h"
#import "Test.h"
#import "StreamKit.h"

@interface SecondController ()

@property (nonatomic,strong) NSString* textContent;

@property (nonatomic,copy) NSDictionary* arr1;

@property (nonatomic,copy) NSDictionary* arr2;

@property (nonatomic,strong) Test *test;

@end

@implementation SecondController

- (Test *)test {
    if (!_test) {
        _test = [Test new];
    }
    return _test;
}

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
    
    [[[NSNotificationCenter defaultCenter] sk_signalWithName:@"111" object:nil] subscribeNext:^(NSNotification* x) {
        NSLog(@"x1 = %@",x.name);
    }];
    [[[NSNotificationCenter defaultCenter] sk_signalWithName:@"222" object:nil] subscribeNext:^(NSNotification *x) {
        NSLog(@"x2 == %@",x.name);
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
