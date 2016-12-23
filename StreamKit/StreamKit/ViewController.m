//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "StreamKit/StreamKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view = UIView.sk_init(CGRectMake(100, 100, 100, 100)).sk_backgroundColor([UIColor redColor]);
    UITapGestureRecognizer* tap = UITapGestureRecognizer.sk_initWithBlock(^(UITapGestureRecognizer* tap){
        NSLog(@"点击了");
    });
    
    UISwipeGestureRecognizer* swipe = UISwipeGestureRecognizer.sk_initWithBlock(^(UISwipeGestureRecognizer* swi) {
        NSLog(@"轻扫了");
    }).sk_direction(UISwipeGestureRecognizerDirectionLeft);
    view.sk_addGestureRecognizer(tap).sk_addGestureRecognizer(swipe);
    [self.view addSubview:view];
    
    UIButton* button = UIButton.sk_initWithFrame(CGRectZero).sk_setTitleNormal(@"").sk_setTitleColorNormal([UIColor blackColor]).sk_setFontSize(14).sk_addEventBlock(UIControlEventTouchUpInside,^(UIButton* button) {
        
    }).sk_addEventBlock(UIControlEventTouchDown,^(UIButton* button) {
        
    }).sk_addEventBlock(UIControlEventAllEvents,^(UIButton* button) {
        
    });
    [self.view addSubview:button];
    
    UITextField* textField = UITextField.sk_init(CGRectMake(200, 100, 100, 30)).sk_textColor([UIColor blackColor]).sk_placeholder(@"kais").sk_textFieldDidEndEditing(^(UITextField* textField) {
    
    }).sk_textFieldShouldChangeCharactersInRange(^BOOL(UITextField* textField,NSRange range,NSString* string){
        
        return YES;
    }).sk_textFieldDidBeginEditing(^(UITextField* textField){
    
    });
    [self.view addSubview:textField];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
