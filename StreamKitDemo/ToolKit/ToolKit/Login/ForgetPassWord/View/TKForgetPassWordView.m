//
//  LJForgetPassWordView.m
//  news
//
//  Created by 奥那 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKForgetPassWordView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface TKForgetPassWordView ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    CGFloat height;
    CGFloat width;
}
@property (nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;//忘记密码scrollview

@end

@implementation TKForgetPassWordView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self customSubViews];
        
    }
    return self;
}

- (void)customSubViews{
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.scrollView];
    [_scrollView addSubview:self.setView];
    
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height+40)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(0, height+40);
    }
    return _scrollView;
}

- (UIView *)setView{
    if (!_setView) {
        //输入view
        _setView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(18, 30, width - 36, 200)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.masksToBounds = YES;
        _inputView.layer.cornerRadius = 6;
        [_setView addSubview:_inputView];
        
        //手机号码输入框
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(24, 0, _inputView.frame.size.width-125, 66)];
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.placeholder = @"+86";
        _phoneTextField.font = [UIFont systemFontOfSize:17];
        [_phoneTextField setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.delegate = self;
        [_inputView addSubview:_phoneTextField];
        
        //验证码button
        _captchaButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _captchaButton.frame = CGRectMake(CGRectGetMaxX(_phoneTextField.frame), 15, 90, 36);
        _captchaButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [_captchaButton setBackgroundImage:[UIImage imageNamed:@"login_sign"] forState:UIControlStateNormal];
        [_captchaButton addTarget:self action:@selector(clickcaptcha:) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:_captchaButton];
        
        //验证码button的显示label
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3, 0, 96, 36)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"发送验证码";
        [_captchaButton addSubview:_timeLabel];
        
        //分隔线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_phoneTextField.frame), _inputView.frame.size.width-18, 0.5)];
        line1.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [_inputView addSubview:line1];
        
        //验证码输入框
        _captchaField = [[UITextField alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(line1.frame), _inputView.frame.size.width-27, 66)];
        _captchaField.font = [UIFont systemFontOfSize:17];
        
        _captchaField.delegate = self;
        _captchaField.keyboardType = UIKeyboardTypeNumberPad;
        _captchaField.placeholder = @"验证码";
        [_captchaField setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _captchaField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputView addSubview:_captchaField];
        
        //分隔线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_captchaField.frame), _inputView.frame.size.width-18, 0.5)];
        line2.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [_inputView addSubview:line2];
        
        //密码输入框
        _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(line2.frame), _inputView.frame.size.width-27, 66)];
        _passWordField.font = [UIFont systemFontOfSize:17];
        
        _passWordField.delegate = self;
        _passWordField.secureTextEntry = YES;
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputView addSubview:_passWordField];
        
        //密码输入框placeholder
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"设置密码  6-15个字符"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0,5)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] range:NSMakeRange(7,string.length-7)];
        _passWordField.attributedPlaceholder = string;
        
        //提交密码button
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(22, CGRectGetMaxY(_inputView.frame)+23, width - 44, 47);
        [_confirmBtn setTitle:@"设置新密码" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [_setView addSubview:_confirmBtn];
        
        self.lineArray = @[line1,line2];
    }
    return _setView;
}

//点击屏幕结束编辑
- (void)endEditAction:(UITapGestureRecognizer *)tap{
    [self endEditing:YES];
}

//发送验证码
- (void)clickcaptcha:(UIButton *)sender{
    if (_captchaBlock) {
        _captchaBlock(_phoneTextField.text);
    }
    [self endEditing:YES];
}

//提交
- (void)clickSubmit:(UIButton *)sender{
    if (_commitBlock) {
        _commitBlock(_phoneTextField.text,_captchaField.text,_passWordField.text);
    }
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate

//点击键盘return按键
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneTextField) {
        [_phoneTextField resignFirstResponder];
        [_captchaField becomeFirstResponder];
    } else if(textField == _captchaField){
        [_captchaField resignFirstResponder];
        [_passWordField becomeFirstResponder];
    } else if(textField == _passWordField){
        [_passWordField resignFirstResponder];
       
    }
    return YES;
}

//手机、验证码禁止输入非数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTextField || textField == _captchaField) {
        return [self validateNumber:string];
    }
    return YES;
}

//判断是否为纯数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


@end
