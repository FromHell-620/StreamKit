//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import <StreamKit/StreamKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     create a label
     */
    UILabel* label = [UILabel new];//UILabel.new
    label.sk_frame(CGRectZero)
    .sk_fontSize(15)
    .sk_textAlignment(NSTextAlignmentCenter)
    .sk_textColor([UIColor redColor])
    .sk_text(@"a label")
    .sk_addSimpleClickAction(^{
    
    });
    [self.view addSubview:label];
    
    /*
     event block
     */
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.sk_frame(CGRectMake(100, 100, 100, 100))
    .sk_setTitleNormal(@"a button")
    .sk_setTitleColorNormal([UIColor redColor])
    .sk_setFontSize(15)
    .sk_addEventBlock(UIControlEventTouchDown,^(UIButton* button){
        
    })
    .sk_addEventBlock(UIControlEventTouchUpInside,^(UIButton* button){
        
    })
    .sk_addEventBlock(UIControlEventTouchUpOutside,^(UIButton* button){
    
    });
    [self.view addSubview:button];
    
    /*
     delegate block
     */
        /*
     KVO
     */
    label.sk_addObserverWithKeyPath(@"text",^(NSDictionary* change){
    
    });
    
    /*
     NSNotification
     */
//    NSNotificationCenter* defaultNotification = [NSNotificationCenter defaultCenter];
//    defaultNotification.sk_addNotification(UITextFieldTextDidChangeNotification,^(NSNotification* noti){
//    
//    })
//    .sk_addNotification(UITextFieldTextDidEndEditingNotification,^(NSNotification* noti){
//    
//    });
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 300, 30)];
    textView.sk_text(@"aaa").sk_textColor([UIColor redColor]).sk_textViewDidChange(^(UITextView* textView){
    
    });
    [self.view addSubview:textView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
