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
    __weak typeof(self) weakSelf = self;

    UILabel* label = [UILabel new];//UILabel.new
    label.sk_frame(CGRectMake(100, 200, 100, 30))
    .sk_fontSize(15)
    .sk_textAlignment(NSTextAlignmentCenter)
    .sk_textColor([UIColor redColor])
    .sk_text(@"a label")
    .sk_addSimpleClickAction(^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
    [self.view addSubview:label];
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 300, 30)];
    textView.sk_text(@"aaa").sk_textColor([UIColor redColor]).sk_textViewDidChange(^(UITextView* textView){
        weakSelf.textContent = textView.text;
    });
    [self.view addSubview:textView];
    SK(label,text,@"我为空了") = SKObserve(self, textContent,@"");
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
