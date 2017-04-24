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
    NSMutableArray<UILabel*>* arr = [NSMutableArray  array];
    for (int i=0; i<3; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+i*80, 200, 70, 60);
        [button setTitle:(@1).stringValue forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, 300, 70, 30)];
        label.text = @"aaa";
        [arr addObject:label];
        [self.view addSubview:button];
        [self.view addSubview:label];
        [[button sk_signalForControlEvents:UIControlEventTouchUpInside] subscribe:^(id x) {
            label.hidden = !label.isHidden;
        }];
        
    }
    
    [[[SKSignal combineLatestSignals:@[[arr[0] sk_ObserveForKeyPath:@"hidden"],[arr[1] sk_ObserveForKeyPath:@"hidden"],[arr[2] sk_ObserveForKeyPath:@"hidden"]]] map:^id(NSDictionary* x) {
        return [x objectForKey:@"new"];
    }] subscribe:^(id x) {
        NSLog(@"%@",x);
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
