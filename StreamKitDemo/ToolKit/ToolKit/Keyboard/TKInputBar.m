//
//  TKInputBar.m
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKInputBar.h"
#import "UIView+Utils.h"
#import "HPGrowingTextView.h"
#import "TKInputPanelView.h"
#import "TKInputEmojiManager.h"
#import "TKInputTextView.h"

#define kHorPadding    10
#define kInputVerPadding 5
#define kInputBgHeight 40 // 36 + 10

#define kSwitchInputHorPadding 5
#define switchWidth 30

@interface TKInputBar ()<HPGrowingTextViewDelegate , TKInputTextViewDelegate , TKInputPanelViewDelegate>

@property(nonatomic , strong) UIView *inputbarBgView;
@property(nonatomic , strong) UIView *panelContainerView;

@property(nonatomic , strong) TKInputTextView *inputTextView;
@property(nonatomic , strong) UIButton *switchButton;
@property(nonatomic , strong) UIFont *inputFont;

@end


@implementation TKInputBar

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame barMode:TKKeyboardBarModeDefault];
}

-(instancetype)initWithFrame:(CGRect)frame barMode:(TKKeyboardBarMode)barMode
{
    CGRect rframe = [[UIScreen mainScreen] bounds];
    rframe.origin.y = frame.origin.y;
    rframe.size.height = kInputBgHeight;
    self = [super initWithFrame: rframe];
    if (self) {
        
        self.maxInputCount = NSIntegerMax;
        self.overMaxCanInput = true;
        
        _inputbarBgView = [[UIView alloc]initWithFrame:CGRectMake(kHorPadding, kInputVerPadding, self.width - 2*kHorPadding, kInputBgHeight-2*kInputVerPadding)];
        CGRect inputFrame ;
        if (barMode == TKKeyboardBarModeTextOnly) {
            inputFrame = CGRectMake(0, 0, _inputbarBgView.width ,  _inputbarBgView.height);
        }else{
            inputFrame = CGRectMake(0, 0, _inputbarBgView.width - kSwitchInputHorPadding - switchWidth ,  _inputbarBgView.height);

        }
        
        _inputTextView = [[TKInputTextView alloc]initWithFrame:inputFrame];
        _inputTextView.isScrollable = false;
        _inputTextView.textContainerInset = UIEdgeInsetsMake(4, 1, 4, 0);
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = true;
        _inputTextView.font = [UIFont systemFontOfSize:18];
        
        _inputTextView.minNumberOfLines = 1;
        _inputTextView.maxNumberOfLines = 3;
                
        _inputTextView.delegate = self;
        _inputTextView.pasteDelegate = self;
        
        _inputTextView.layer.borderColor = [[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0] CGColor];
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.backgroundColor = [UIColor whiteColor];
        
        if (barMode != TKKeyboardBarModeTextOnly) {
            
            _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
            _switchButton.frame = CGRectMake(_inputTextView.right , (_inputbarBgView.height -switchWidth)/2 , self.width - _inputTextView.right - kHorPadding, switchWidth);
            [_inputbarBgView addSubview:_switchButton];
        }
        [_inputbarBgView addSubview:_inputTextView];
        
        
        [self addSubview:_inputbarBgView];

        _inputbarBgView.backgroundColor = [UIColor whiteColor];
        _panelContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, _inputbarBgView.bottom+kInputVerPadding, self.width, self.height - _inputbarBgView.bottom - kInputVerPadding)];
        [self addSubview:_panelContainerView];
        
        [self addKeyboardObserver];
        
        self.inputFont = _inputTextView.font;
        self.mode = TKKeyboardModeText;
        
        [self updateSwitchButton];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(instancetype)init
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    return [self initWithFrame:frame];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)resignFirstResponder
{
    if (self.mode == TKKeyboardModeText) {
        return [_inputTextView resignFirstResponder];
    }else{
    
        CGRect frame = self.frame;
        frame.origin.y = self.superview.height - self.inputbarBgView.height - 2*kInputVerPadding;
        
        
        NSTimeInterval duration = 0.3;
        [UIView animateWithDuration:duration animations:^{
            self.frame = frame;
        }];
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:willChangeToFrame:withDuration:)] ){
            [self.delegate inputBar:self willChangeToFrame:self.frame withDuration:duration];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidEndEditing:)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate inputBarDidEndEditing:self];
            });
        }
        
        self.mode = TKKeyboardModeText;
        
        [self updateSwitchButton];
    }
    
    return true;
}

-(BOOL)becomeFirstResponder
{
    return [_inputTextView becomeFirstResponder];
}

-(BOOL)isFirstResponder
{
    if ([_inputTextView isFirstResponder]) {
        return true;
    }
    if (self.height > self.inputbarBgView.height || self.mode != TKKeyboardModeText) {
        return true;
    }
    
    return [super isFirstResponder];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _inputTextView.placeholder = placeholder;
}

-(void)setText:(NSString *)text
{
    [_inputTextView setText:text];
}
-(void)setSendBgColor:(UIColor *)sendBgColor
{
    _sendBgColor = sendBgColor;
    
}

-(NSString *)toSendText
{
    return [_inputTextView plainText];
}


-(void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (UIView*)staticSuperView
{
    return [UIApplication sharedApplication].keyWindow;
}

-(CGFloat)showHeight
{
    if (_mode == TKKeyboardModeText) {
        return self.inputbarBgView.height;
    }else{
        return self.panelContainerView.bottom;
    }
}

-(void)switchAction:(id)sender
{
    BOOL shouldChange = true;
    if ([_delegate respondsToSelector:@selector(inputBarWillStartEditing:withMode:)]) {
        TKKeyboardMode mode = TKKeyboardModeText;
        if (self.mode == TKKeyboardModeText) {
            mode = TKKeyboardModeEmoji;
        }
        shouldChange = [_delegate inputBarWillStartEditing:self withMode:mode];
    }
    if (shouldChange) {
        [self updateMode];
    }
    
}

-(void)updateMode
{
    if (self.mode == TKKeyboardModeText) {
        self.mode = TKKeyboardModeEmoji;
        [self.inputTextView resignFirstResponder];
        [self showEmojiPanel:true];
    }else if(self.mode == TKKeyboardModeEmoji){
        self.mode = TKKeyboardModeText;
        [self.inputTextView becomeFirstResponder];
    }
    [self updateSwitchButton];
    
    if (_updateModeBlock) {
        _updateModeBlock(self.mode);
    }
}

-(void)updateSwitchButton
{
    UIImage *image = nil;
    if (self.mode == TKKeyboardModeText) {
        image = [TKInputEmojiManager faceImage];
    }else{
        image = [TKInputEmojiManager keyboardImage];
    }
    
    [_switchButton setImage:image forState:UIControlStateNormal];
    
}

-(void)showEmojiPanel:(BOOL)animated
{
    TKInputPanelView *panel = [TKInputPanelView sharedInstance];

    panel.delegate =self;
    
    panel.sendBgColor = self.sendBgColor;
    self.panelContainerView.height = panel.height;
    self.panelContainerView.top = self.inputbarBgView.bottom + kInputVerPadding;
    self.height = self.panelContainerView.bottom;
    [self.panelContainerView addSubview:panel];
    
    self.top = self.superview.height - self.height;
    
    panel.top = self.panelContainerView.height;
    
    CGFloat duration = 0.4;
    [UIView animateWithDuration:duration animations:^{
        panel.top = 0;
    }];
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:willChangeToFrame:withDuration:)] ){
        [self.delegate inputBar:self willChangeToFrame:self.frame withDuration:0];
    }
}


-(void)panel:(TKInputPanelView *)panel chooseItem:(TKInputEmojiItem *)item
{
    TKInputAttachment *attachment = [[TKInputAttachment alloc]init];
    attachment.image = item.image;
    attachment.emojiName = item.name;
    
    attachment = [[TKInputEmojiManager sharedInstance]attachmentForName:item.name];
    
    
    CGFloat width = ceil(self.inputFont.lineHeight);
    attachment.bounds = CGRectMake(0, -3,width ,width);
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]init];
    if (_inputTextView.attributedText) {
        [content appendAttributedString:_inputTextView.attributedText];
    }
    
    [content appendAttributedString:imageStr];
    [content addAttributes:@{NSFontAttributeName:self.inputFont} range:NSMakeRange(content.length -1 , 1)];
    _inputTextView.attributedText = content;
    //    _inputTextView.font = self.inputFont;

}
-(void)panelDoDelete:(TKInputPanelView *)panel
{
    if (_inputTextView.attributedText) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]init];
        [content appendAttributedString:_inputTextView.attributedText];
        if (content.length > 0) {
            [content deleteCharactersInRange:NSMakeRange(content.length -1 , 1)];
        }
        _inputTextView.attributedText = content;
    }
}


-(void)panelDoSend:(TKInputPanelView *)panel
{
    if ([_delegate respondsToSelector:@selector(inputBarShouldReturn:)]) {
        [_delegate inputBarShouldReturn:self];
    }
}


-(void)keyboardWillShowNotification:(NSNotification *)notification
{
    
    if (self.mode != TKKeyboardModeText) {
        return;
    }
    
    if( self.window == nil ){
        return;
    }
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    keyboardFrame = [self.superview convertRect:keyboardFrame fromView:[self staticSuperView]];
    
    CGRect targetRect = self.frame;
    targetRect.origin.y = self.superview.frame.size.height - keyboardFrame.size.height-targetRect.size.height;
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:willChangeToFrame:withDuration:)] )
        [self.delegate inputBar:self willChangeToFrame:targetRect withDuration:animationDuration];
    
    [UIView beginAnimations:nil context:(__bridge void *)([NSValue valueWithCGRect:targetRect])];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(inputKeyboardWillShowAnimationDidStop:finished:context:)];
    
    self.frame = targetRect;
    
    [UIView commitAnimations];
    
}

-(void)keyboardChangeNotification:(NSNotification *)notification
{
    if (self.mode != TKKeyboardModeText) {
        return;
    }
    
    if( self.window == nil ){
        return;
    }
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    keyboardFrame = [self.superview convertRect:keyboardFrame fromView:[self staticSuperView]];
    
    CGRect targetRect = self.frame;
    targetRect.origin.y = self.superview.frame.size.height - keyboardFrame.size.height-targetRect.size.height;
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:willChangeToFrame:withDuration:)] )
        [self.delegate inputBar:self willChangeToFrame:targetRect withDuration:animationDuration];
    
    [UIView beginAnimations:nil context:(__bridge void *)([NSValue valueWithCGRect:targetRect])];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(inputKeyboardWillShowAnimationDidStop:finished:context:)];
    
    self.frame = targetRect;
    
    [UIView commitAnimations];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    if (self.mode != TKKeyboardModeText) {
        return;
    }
    if( self.window == nil ){
        return;
    }
//    if( self.targetKeyboardType != QSInputBarMode_None )return;
    
    CGRect rect = self.frame;
    rect.origin.y = self.superview.frame.size.height - rect.size.height;
    
    NSTimeInterval animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:willChangeToFrame:withDuration:)] ){
        [self.delegate inputBar:self willChangeToFrame:rect withDuration:animationTime];
    }
    
    [UIView beginAnimations:nil context:(__bridge void *)([NSValue valueWithCGRect:rect])];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(inputKeyboardWillShowAnimationDidStop:finished:context:)];
    
    self.frame = rect;
    
    [UIView commitAnimations];
    
}

- (void)inputKeyboardWillShowAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(NSValue *)context
{
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:didChangeToFrame:)] )
        [self.delegate inputBar:self didChangeToFrame:[context CGRectValue]];
}

#pragma mark - input
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(![growingTextView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
//        if (self.doSendBlock) {
//            self.doSendBlock();
//        }
        if ([_delegate respondsToSelector:@selector(inputBarShouldReturn:)]) {
            [_delegate inputBarShouldReturn:self];
            
        }
        
        return NO;
    }
    NSMutableString *content = [[NSMutableString alloc]initWithString:growingTextView.text];
    [content replaceCharactersInRange:range withString:text];
    
    //输入字数超限后提示
    if (content.length>_maxInputCount && self.inputOverLimitBlock) {
        self.inputOverLimitBlock(content.length);
//        return false;
        return self.overMaxCanInput;
    }
    
    return true;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length>_maxInputCount && self.inputOverLimitBlock) {
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithAttributedString: growingTextView.attributedText];
        [attr replaceCharactersInRange:NSMakeRange(self.maxInputCount, attr.length - self.maxInputCount) withString:@""];
        growingTextView.attributedText = attr;
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{        
    CGFloat barHeight = height + 2*kInputVerPadding;
    _inputbarBgView.height = height;
    
    _panelContainerView.top = _inputbarBgView.bottom + kInputVerPadding;
    
    CGRect frame = self.frame;
    if (self.mode == TKKeyboardModeText) {
        frame.origin.y = (CGRectGetMaxY(frame) - barHeight);
        frame.size.height = barHeight;
    }else{
        frame.origin.y = CGRectGetMaxY(frame) - _panelContainerView.bottom;
        frame.size.height = _panelContainerView.bottom;
    }


    CGFloat duration = 0.2;
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    }];
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:willChangeToFrame:withDuration:)] ){
        [self.delegate inputBar:self willChangeToFrame:self.frame withDuration:duration];
    }
    
    
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
{
    if( self.delegate && [self.delegate respondsToSelector:@selector(inputBar:didChangeToMode:)] ){
        [self.delegate inputBar:self didChangeToFrame:self.frame];
    }
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    BOOL shouldBegin = true;
    if ([_delegate respondsToSelector:@selector(inputBarWillStartEditing:withMode:)]) {
        shouldBegin = [_delegate inputBarWillStartEditing:self withMode:TKKeyboardModeText];
    }
    if (shouldBegin) {
        self.mode = TKKeyboardModeText;
        self.height = self.inputbarBgView.height + 2*kInputVerPadding;
        [self updateSwitchButton];
    }    
    return true;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    if ([_delegate respondsToSelector:@selector(inputBarDidStartEditing:)]) {
        [_delegate inputBarDidStartEditing:self];
    }
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    
    if ((_mode == TKKeyboardModeText || _mode == TKKeyboardModeNone) && [_delegate respondsToSelector:@selector(inputBarDidEndEditing:)]) {
        [_delegate inputBarDidEndEditing:self];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(inputBarShouldReturn:)]) {
        return [_delegate inputBarShouldReturn:self];
    }
    return true;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if ([_delegate respondsToSelector:@selector(inputBarShouldReturn:)]) {
        return [_delegate inputBarShouldReturn:self];
    }
    return true;
}

-(void)pasteContent:(NSString *)content
{
    if (content.length > self.maxInputCount) {
        content = [content substringToIndex:self.maxInputCount - 1];
    }
    
    NSAttributedString *attrContent = [[TKInputEmojiManager sharedInstance] toEmojiWithString:content andFont:self.inputTextView.font];
    self.inputTextView.attributedText = attrContent;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
