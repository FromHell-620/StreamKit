//
//  TKLoginWithEmailView.m
//  ToolKit
//
//  Created by 奥那 on 16/1/6.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKLoginWithEmailView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface TKLoginWithEmailView ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    CGFloat height;
    CGFloat width;
}
@property (nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;


@end

@implementation TKLoginWithEmailView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self customSubViews];
    
    }
    return self;
}

- (TPKeyboardAvoidingScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height+40)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(0, height+40);
    }
    return _scrollView;
}

- (void)customSubViews{
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.inputView];
    
}

- (UIView *)inputView{
    if (!_inputView) {
        //输入view
//        self.inputView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, width-36, 270)];
        
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(18, 30, width - 36, 132)];
        _inputView.layer.masksToBounds = YES;
        _inputView.layer.cornerRadius = 6;
        [self addSubview:_inputView];
        
        //邮箱输入框
        _emailField = [[UITextField alloc] initWithFrame:CGRectMake(24, 0, _inputView.frame.size.width-27, 66)];
        _emailField.font = [UIFont systemFontOfSize:17];
        _emailField.placeholder = @"邮箱";
        [_emailField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _emailField.delegate = self;
        _emailField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_inputView addSubview:_emailField];
        
        //分割线
        _line2 = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_emailField.frame), _inputView.frame.size.width-18, 0.5)];
        _line2.backgroundColor = [UIColor grayColor];
        [_inputView addSubview:_line2];
        
        //密码输入框
        _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(_line2.frame), _inputView.frame.size.width-27, 66)];
        _passWordField.font = [UIFont systemFontOfSize:17];
        _passWordField.delegate = self;
        _passWordField.secureTextEntry = YES;
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputView addSubview:_passWordField];
        
        //密码输入框placeholder
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"密码  6-15个字符"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,2)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4,string.length-4)];
        _passWordField.attributedPlaceholder = string;
        
        //登录按钮
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(22, CGRectGetMaxY(_inputView.frame)+23, width - 45, 47);
        [_confirmBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
    }
    return _inputView;
}

- (void)clickLogin:(UIButton *)sender{
    if (_loginWithEmail) {
        _loginWithEmail(_emailField.text,_passWordField.text);
    }
}
@end
