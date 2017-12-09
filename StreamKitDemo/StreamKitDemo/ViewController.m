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
   SKSignal *signal1 = [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [subscriber sendComplete:@1];
       });
   }];
    SKSignal *signal2 = [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendComplete:@1];
        });
    }];
    SKSignal *signal3 = [signal1 concat:signal2];
    [signal3 subscribe:^(id x) {
        
    } complete:^(id value) {
        
    }];
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
