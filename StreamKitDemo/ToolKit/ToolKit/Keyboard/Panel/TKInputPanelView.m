//
//  TKInputPanelView.m
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKInputPanelView.h"
#import "TKKeyboardItemCollectionViewLayout.h"
#import "TKEmojiToolbar.h"
#import "UIView+Utils.h"
#import "TKInputEmojiCollectionViewCell.h"
#import "TKInputEmojiManager.h"

#define kCollectionTopPadding 15
#define kPageControlHeight    15
#define kToolbarHeight        30

#define kEmojiWidth           30
#define kEmojiPageInset       20


@interface TKInputPanelView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong) UICollectionView *emojiCollectionView;
@property(nonatomic , strong) UIPageControl *pageControl;
@property(nonatomic , strong) TKEmojiToolbar *toolbar;
@property(nonatomic , assign) NSInteger currentEmotionIndex;
@property(nonatomic , assign) NSInteger pageCount;

@end

@implementation TKInputPanelView

+(TKInputPanelView *)sharedInstance
{
    static TKInputPanelView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKInputPanelView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 240)];
    });
    return instance;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        
        CGRect emojiFrame = self.bounds;
        emojiFrame.origin.y = kCollectionTopPadding;
        emojiFrame.size.height -= (kPageControlHeight + kToolbarHeight + emojiFrame.origin.y);
        
        NSInteger rowCount = [self numberOfRows];
        TKKeyboardItemCollectionViewLayout *layout = [[TKKeyboardItemCollectionViewLayout alloc]init];
        layout.itemSize = CGSizeMake(kEmojiWidth, kEmojiWidth);
        layout.lineSpacing = (emojiFrame.size.height)/[self numberOfRows] - kEmojiWidth;
        layout.itemSpacing = floor((self.width - 2*kEmojiPageInset - [self numberItemsPerRow]*kEmojiWidth)/([self numberItemsPerRow] -1));
        layout.pageContentInsets = UIEdgeInsetsMake(0, kEmojiPageInset, 0, kEmojiPageInset);
        
        _emojiCollectionView = [[UICollectionView alloc]initWithFrame:emojiFrame collectionViewLayout:layout];
        _emojiCollectionView.delegate = self;
        _emojiCollectionView.dataSource = self;
        _emojiCollectionView.pagingEnabled = true;
        _emojiCollectionView.showsHorizontalScrollIndicator = false;
        _emojiCollectionView.showsVerticalScrollIndicator = false;
        
        
        [_emojiCollectionView registerClass:[TKInputEmojiCollectionViewCell class] forCellWithReuseIdentifier:@"emoji"];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _emojiCollectionView.bottom, self.width, kPageControlHeight)];
        
        _toolbar = [[TKEmojiToolbar alloc]initWithFrame:CGRectMake(0, self.height - kToolbarHeight, self.width, kToolbarHeight)];
        _pageControl.centerX = self.width/2;
        _pageControl.bottom = _toolbar.top;
        
        [self addSubview:_emojiCollectionView];
        [self addSubview:_pageControl];
        [self addSubview:_toolbar];
        
        NSArray *allEmotions = [[TKInputEmojiManager  sharedInstance] allEmotions];
        NSMutableArray *toolbarItems = [[NSMutableArray alloc]init];
        for (NSArray *emos in allEmotions) {
            TKInputEmojiItem *item = [emos firstObject];
            if (item.image) {
                [toolbarItems addObject:item.image];
            }else{
                NSLog(@"image is nil");
            }
            
        }
        [_toolbar updateWithIcons:toolbarItems];
        _currentEmotionIndex = 0;
        
        __weak typeof(self) wself = self;
        _toolbar.chooseAtIndex = ^(NSInteger index){
            if (wself.currentEmotionIndex != index) {
                wself.currentEmotionIndex = index;
                wself.pageCount = [wself numberOfPages];
                wself.pageControl.currentPage = 0;
                [wself.emojiCollectionView reloadData];
                wself.emojiCollectionView.contentOffset = CGPointZero;
                
            }
        };
        _toolbar.sendBlock = ^{
            if ([wself.delegate respondsToSelector:@selector(panelDoSend:)]) {
                [wself.delegate panelDoSend:wself];
            }
        };
        
        _pageControl.numberOfPages = [self numberOfPages];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        
        _emojiCollectionView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setSendBgColor:(UIColor *)sendBgColor
{
    _toolbar.sendBgColor = sendBgColor;
}

-(UIColor *)sendBgColor
{
    return _toolbar.sendBgColor;
}

-(NSInteger)numberItemsPerRow
{
    CGFloat screenWidth = SCREEN_WIDTH;
    if (screenWidth <= 320) {
        return 7;
    }else if (screenWidth < 376){
        return 8;
    }else if(screenWidth < 415){
        return 9;
    }
    return 7;
}

-(NSInteger)numberOfRows
{
    return 4;
}

-(NSInteger)numberOfPages
{
    NSArray *allEmotions = [[TKInputEmojiManager sharedInstance]allEmotions];
    NSArray *emos = allEmotions[_currentEmotionIndex];
    NSInteger count = 0;
    NSInteger rows = [self numberOfRows];
    NSInteger cols = [self numberItemsPerRow];
    NSInteger itemsPerPage = rows*cols - 1;
    
    return  ([emos count] + itemsPerPage - 1)/itemsPerPage;
    
}

-(NSInteger)itemCount
{
    NSArray *allEmotions = [[TKInputEmojiManager sharedInstance]allEmotions];
    NSArray *emos = allEmotions[_currentEmotionIndex];
    return [emos count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self itemCount];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKInputEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emoji" forIndexPath:indexPath];
    
    NSInteger rows = [self numberOfRows];
    NSInteger cols = [self numberItemsPerRow];
    if ((indexPath.item == [self itemCount] -1) ||  (indexPath.item+1) % (rows*cols) == 0) {
        //页尾
        TKInputEmojiItem *item = [TKInputEmojiManager deleteEmojiItem];
        [cell updateWithEmoji:item];
        
    }else{
        
        NSArray *allEmotions = [[TKInputEmojiManager sharedInstance]allEmotions];
        NSArray *emos = allEmotions[_currentEmotionIndex];
        
        NSInteger index = indexPath.item - indexPath.item/(rows*cols) ;
        TKInputEmojiItem *item = emos[index];
                
        [cell updateWithEmoji:item];
    }    
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKInputEmojiCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    TKInputEmojiItem *item = [cell emojiItem];
    if (item.name) {
        if ([_delegate respondsToSelector:@selector(panel:chooseItem:)]) {
            [_delegate panel:self chooseItem:item];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(panelDoDelete:)]) {
            [_delegate panelDoDelete:self];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger pageIndex = offset.x / scrollView.width;
    self.pageControl.currentPage = pageIndex;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
