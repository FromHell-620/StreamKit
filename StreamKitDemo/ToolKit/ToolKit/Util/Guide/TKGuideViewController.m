//
//  TKGuideViewController.m
//  MeiYuanBang
//
//  Created by chunhui on 15/6/3.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKGuideViewController.h"
#import "TKGuidTransitionDelegate.h"
#import "TKGuidePageControl.h"

//#define kTotoalCount 3

@interface TKGuideViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@property(nonatomic , strong) UIScrollView *scrollView;
@property(nonatomic , strong) TKGuidTransitionDelegate *transDelegate;
@property(nonatomic , strong) TKGuidePageControl *pageControl;
@property(nonatomic , strong) UIButton *enterButton;

@end

@implementation TKGuideViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.transDelegate = [TKGuidTransitionDelegate new];
        self.transitioningDelegate = self.transDelegate;
    }
    return self;
}

-(void)loadGuide
{
    UIImageView *imageView;
    UIImage *image;
    CGRect frame = [[UIScreen mainScreen] bounds];
    for (int i = 0; i < self.guideImages.count ; i++) {
        image = self.guideImages[i];
        imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = image;
        frame.origin.x += CGRectGetWidth(frame);
        [_scrollView addSubview:imageView];
        
        if (i == self.guideImages.count - 1 && _isHiddenTouchLast) {
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterAction)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:imageTap];
            
            if (_showDuration > 0) {
                NSTimer *timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(enterAction) userInfo:nil repeats:NO];
                [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
                timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_showDuration];
            }
        }
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame)*self.guideImages.count, CGRectGetHeight(frame));
    _pageControl.numberOfPages = self.guideImages.count;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect bounds = [[UIScreen mainScreen]bounds];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.pagingEnabled = true;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    if (_showPageControl) {
        
        _pageControl = [[TKGuidePageControl alloc]initWithFrame:CGRectMake(bounds.size.width/2 - 25, bounds.size.height - 25, 40, 10)];
        _pageControl.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_pageControl];
        
    }
    
    _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat height = 45;
    CGFloat gap = 50;
    if (fabs(bounds.size.height - 480) < 5) {
        //4
        gap = 38;
    }else if (fabs(bounds.size.height - 568) < 5){
        //5
        gap = 45;
        height = 40;
    }else if (fabs(bounds.size.height - 667) < 5){
        //6
        gap = 50;
        height = 50;
    }else{
        //6p
        gap = 57;
        height = 56;
    }
    _enterButton.frame = CGRectMake(bounds.size.width/4, bounds.size.height - gap - height, bounds.size.width/2, height);
    _enterButton.backgroundColor = [UIColor clearColor];
    [_enterButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_enterButton];
    _enterButton.hidden = YES;
    
    [self loadGuide];
    _scrollView.pagingEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pageControl.currentPage = 0;
    
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.modalPresentationStyle = UIModalPresentationNone;
    
    
    if (_tapLastToQuit) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToQuitAction:)];
        [self.scrollView addGestureRecognizer:gesture];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)enterAction
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)special
{
    if (!special) {
        self.transitioningDelegate = nil;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (_quitBlock) {
            _quitBlock();
        }
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.showPageControl) {
        _pageControl.currentPage =  scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        _pageControl.hidden = _pageControl.currentPage == 2;
        _enterButton.hidden = !_pageControl.hidden;
    }
    
    
    NSInteger count = self.guideImages.count;
    
    if (scrollView.contentOffset.x > (count - 1 )*CGRectGetWidth(scrollView.frame)+2) {
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.bounds)*(count - 1), 0);
        _scrollView.userInteractionEnabled = false;
        [self dismiss:YES];
    }
}

-(void)tapToQuitAction:(id)sender
{
    if ((self.scrollView.contentOffset.x +10 )/self.scrollView.frame.size.width >= _guideImages.count - 1 ) {
        
        _scrollView.userInteractionEnabled = false;
        [self dismiss:YES];
    }
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
