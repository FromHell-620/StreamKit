//
//  TKShareView.m
//  Find
//
//  Created by chunhui on 15/5/26.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKShareView.h"
#define kTopPadding     10
#define kShareIconWidth 60
#define kShareIconHeight kShareIconWidth
#define kShareNameToIconTopPadding 10
#define kShareNameWidth  kShareIconWidth
#define kShareNameHeight 20
#define kBottomPadding  10

@interface TKShareContentView : UIView

@property(nonatomic , strong) UIButton *qqButton;
@property(nonatomic , strong) UILabel *qqLabel;
@property(nonatomic , strong) UIButton *wxButton;
@property(nonatomic , strong) UILabel *wxLabel;
@property(nonatomic , strong) UIButton *wxFriendButton;
@property(nonatomic , strong) UILabel *wxFriendLabel;
@property(nonatomic , strong) UIButton *sinaButton;
@property(nonatomic , strong) UILabel *sinaLabel;

@property(nonatomic , copy)void((^shareTo)(TKSharePlatform platform));

@end

@interface TKShareView ()

@property(nonatomic , strong) TKShareContentView *contentView;

@end

@implementation TKShareView

+(TKShareView *)DefaultShareView
{
    TKShareView *shareView = [[TKShareView alloc]initWithFrame:CGRectZero];
    
    return shareView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
        _contentView = [[TKShareContentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTopPadding+kShareIconHeight+kShareNameToIconTopPadding+kShareNameHeight+kBottomPadding)];
        __weak TKShareView *weakSelf = self;
        _contentView.shareTo = ^(TKSharePlatform platform){
            [weakSelf shareTo:platform];
        };
        [self addSubview:_contentView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:recognizer];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    self.frame = view.bounds;
    
    CGRect frame = _contentView.frame;
    frame.origin.y = CGRectGetHeight(self.bounds);
    _contentView.frame = frame;
    
    [view addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect toFrame = _contentView.frame;
        toFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(toFrame);
        _contentView.frame = toFrame;
    }];
    
}

-(void)dismiss
{
    if (!self.superview) {
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = _contentView.frame;
        frame.origin.y = CGRectGetHeight(self.bounds);
        _contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)tapAction:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, location)) {
        [self shareTo:TKSharePlatformInvalid];
    }
}

-(void)shareTo:(TKSharePlatform)platform
{
    if (self.shareTo) {
        _shareTo(platform);
    }
    
    [self dismiss];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation TKShareContentView

-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        if ([TKShareManager isQQInstalled]) {
            _qqLabel = [self shareLabel:@"QQ"];
            _qqButton = [self shareButton:@"share_qq"];
            
            [self addSubview:_qqButton];
            [self addSubview:_qqLabel];
        }
        
        if ([TKShareManager isWeixinInstalled]) {
            _wxLabel = [self shareLabel:@"微信"];
            _wxButton = [self shareButton:@"share_weixin"];
            
            _wxFriendLabel = [self shareLabel:@"朋友圈"];
            _wxFriendButton = [self shareButton:@"share_wx_friend"];
            
            [self addSubview:_wxLabel];
            [self addSubview:_wxButton];
            
            [self addSubview:_wxFriendButton];
            [self addSubview:_wxFriendLabel];
        }
        
        _sinaButton = [self shareButton:@"share_sina"];
        _sinaLabel  = [self shareLabel:@"新浪"];
        
        [self addSubview:_sinaLabel];
        [self addSubview:_sinaButton];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(UIButton *)shareButton:(NSString  *)imageName
{
    CGRect iconFrame = CGRectMake(0, kTopPadding, kShareIconWidth, kShareIconHeight);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = iconFrame;
    [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    
    return button;
}

-(UILabel *)shareLabel:(NSString *)text
{
    CGRect nameFrame = CGRectMake(0, kTopPadding+kShareIconHeight+kShareNameToIconTopPadding, kShareNameWidth, kShareNameHeight);
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.frame = nameFrame;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    
    return label;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = (CGRectGetWidth(self.bounds) - 4*kShareIconWidth)/5;
    
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *labels = [[NSMutableArray alloc]initWithCapacity:4];
    
    if (_qqButton) {
        [buttons addObject:_qqButton];
        [labels  addObject:_qqLabel];
    }
    if (_wxButton) {
        [buttons addObject:_wxButton];
        [buttons addObject:_wxFriendButton];
        
        [labels addObject:_wxLabel];
        [labels addObject:_wxFriendLabel];

    }
    
    [buttons addObject:_sinaButton];
    [labels addObject:_sinaLabel];
    
    UIButton *button;
    UILabel *label ;
    CGRect frame;
    for (int i = 0 ; i < [buttons count]; i++) {
        button = buttons[i];
        label  = labels[i];
        
        frame = button.frame;
        frame.origin.x = padding+(CGRectGetWidth(frame)+padding)*i;
        
        button.frame = frame;
        
        frame = label.frame;
        frame.origin.x = CGRectGetMinX(button.frame);
        
        label.frame = frame;
        
    }
    
}

-(void)shareAction:(UIButton *)sender
{
    if (_shareTo) {
        
        TKSharePlatform platform = TKSharePlatformInvalid;
        if (sender == _qqButton) {
            platform = TKSharePlatformQQ;
        }else if (sender == _wxButton){
            platform = TKSharePlatformWXSession;
        }else if (sender == _wxFriendButton){
            platform = TKSharePlatformWXTimeline;
        }else if (sender == _sinaButton){
            platform = TKSharePlatformSinaWeibo;
        }
        _shareTo(platform);
    }
}

@end
