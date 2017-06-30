//
//  TKAdScrollView.m
//  ToolKit
//
//  Created by chunhui on 15/11/1.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKBannerView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Utils.h"
#import "TKPageControl.h"

#define kBannerTag 1000

@interface TKBannerContentView : UIView

@property(nonatomic , strong) UIImageView *imageView;
@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UIImageView *bannerBlurView;


-(void)updateWithModel:(TKBannerItem *)model;

@end

@interface TKBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic , strong) UICollectionView *containerView;
@property(nonatomic , strong) NSArray *items;
@property(nonatomic , strong) NSMutableArray *itemViews;
@property(nonatomic , strong) NSTimer *scrollTimer;

@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UIView *bannerView;
@property(nonatomic , strong) TKPageControl *pageControl;

@property(nonatomic , assign) BOOL scrollInc;//滚动的方向
@property(nonatomic , strong) UIImage *pageShowImage;
@property(nonatomic , strong) UIImage *pageHighShowImage;


@end

@implementation TKBannerView

#define kHorPadding   12


-(UIView *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [[UIView alloc]initWithFrame:CGRectZero];
        _bannerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _bannerView.userInteractionEnabled = NO;
                
    }
    return _bannerView;
}

-(UILabel  *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(TKPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[TKPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.circleDot = YES;
    }
    return _pageControl;
}
-(void)setPageLocation:(TKBannerPageControlLocation)pageLocation
{
    _pageLocation = pageLocation;
    if (!_bannerView || _bannerView.hidden) {
        //显示page control
        [self setNeedsLayout];
    }
}

-(void)setPageIndicatorSize:(CGSize)pageIndicatorSize
{
    _pageIndicatorSize = pageIndicatorSize;
    self.pageControl.indicatorSize = pageIndicatorSize;
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

-(UICollectionView *)containerView
{
    if (_containerView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        
        _containerView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _containerView.dataSource = self;
        _containerView.delegate = self;
        _containerView.pagingEnabled = YES;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.contentInset = UIEdgeInsetsZero;
        _containerView.scrollsToTop = NO;
        
        [_containerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell_id"];
        
    }
    return _containerView;
}

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemViews = [[NSMutableArray alloc]initWithCapacity:[items count]];
        
        [self addSubview:self.containerView];
        _showDuration = 5;
        _scrollInc = YES;
        _cycleShow = YES;
        _bannerScrollHeight = 40;
        
        [self updateWithItems:items];
        self.backgroundColor = [UIColor whiteColor];
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self stopScroll];
    }
}

-(void)setBannerScrollHeight:(CGFloat)bannerScrollHeight
{
    _bannerView.height = bannerScrollHeight;
    _bannerView.bottom = self.bottom;
}

-(void)setTitleInCell:(BOOL)titleInCell
{
    _titleInCell = titleInCell;
    _titleLabel.hidden = titleInCell;
    _bannerView.hidden = titleInCell;
}

-(void)updateWithItems:(NSArray *)items
{
    if ([items count] == 0) {
        return;
    }
    
    self.items = items;
    
    TKBannerItem *model = [items firstObject];
    if (model.title) {
        //有title
        self.bannerView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - _bannerScrollHeight, CGRectGetWidth(self.bounds), _bannerScrollHeight);
        [self addSubview:_bannerView];
        self.titleLabel.text = model.title;
        [_titleLabel sizeToFit];
        [self.bannerView addSubview:_titleLabel];
        [self.bannerView addSubview:self.pageControl];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _bannerView.hidden = NO;
    }else{
        _bannerView.hidden = YES;
        [self addSubview:self.pageControl];
    }
    
    self.pageControl.currentPage = 0 ;
    self.pageControl.numberOfPages = [items count];
    [self.pageControl sizeToFit];
    self.pageControl.width = 16*([items count]+1);
    
    [self setNeedsLayout];
    [self.containerView reloadData];
    [self.containerView layoutIfNeeded];
    
    self.pageControl.hidden = items.count <= 1;
    if (!self.pageControl.hidden) {
        NSInteger startIndex = 0;
        if (_cycleShow) {
            startIndex = 1;
        }
        [self.containerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:startIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
    }
}

-(void)setCycleShow:(BOOL)cycleShow
{
    _cycleShow = cycleShow;
    [self.containerView reloadData];
}

-(void)startScroll
{
    if (_scrollTimer) {
        [_scrollTimer invalidate];
    }
    if ([_items count] > 1) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:_showDuration target:self selector:@selector(doScroll:) userInfo:nil repeats:YES];
    }
}
-(void)stopScroll
{
    if (_scrollTimer) {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
}


-(void)doScroll:(id)sender
{
    if (sender && [_items count] > 1) {
        
        NSInteger page = self.pageControl.currentPage;
        if (_cycleShow) {
            page++;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page+1 inSection:0];
            [self.containerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            
            if (page >= _items.count) {
                page = 0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page+1 inSection:0];
                    [self.containerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
                });
            }
            
            self.pageControl.currentPage = page;
            
            
        }else{
            
            if (_scrollInc) {
                page++;
                if (page >= [self.items count]) {
                    page = [self.items count] - 2;
                    _scrollInc = NO;
                }
            }else{
                page--;
                if (page < 0) {
                    page = 1;
                    _scrollInc = YES;
                }
            }
            
            self.pageControl.currentPage = page ;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
            [self.containerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        }
        
        TKBannerItem *item = [self.items objectAtIndex:page];
        _titleLabel.text = item.title;
        [self setNeedsLayout];
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_bannerView && !_bannerView.hidden) {
        [self bringSubviewToFront:_bannerView];
        CGSize pageSize = CGSizeMake(15*[self.items count] - 8, 8);

        _bannerView.bottom = self.height;
        _bannerView.width = self.width;
        
        
        switch (_pageLocation) {
            case kTKBannerLocationLeft:
                self.pageControl.left = 0;
                break;
            case kTKBannerLocationCenter:
            {
                self.pageControl.centerX = self.width/2;
                
                if (  self.titleLabel.numberOfLines > 1) {
                    
                    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.width - 2*kHorPadding, 1000)];
                    
                    if (size.height + pageSize.height*2 > _bannerView.height) {
                        _bannerView.height = size.height + pageSize.height*2;
                    }else{
                        _bannerView.height = _bannerScrollHeight;
                    }
                    
                    _titleLabel.size = size;
                    _bannerView.bottom = self.height;
                    
                }
                
                self.titleLabel.frame =  CGRectMake(kHorPadding, 2,  self.width - 2*kHorPadding  , _bannerView.height - pageSize.height*2);
                
                self.pageControl.centerY = _titleLabel.bottom + pageSize.height/2 ;
                
                [_bannerView bringSubviewToFront:self.pageControl];
            }
                break;
            case kTKBannerLocationRight:
                
                self.pageControl.frame = CGRectMake(_bannerView.width - kHorPadding - pageSize.width, (_bannerView.height - pageSize.height)/2, pageSize.width, pageSize.height);
                self.titleLabel.frame = CGRectMake(kHorPadding, 0,  self.width - 2*kHorPadding - _pageControl.width -10 , _bannerView.height);
                break;
            default:
                break;
        }
        
    }else{
        switch (_pageLocation) {
            case kTKBannerLocationLeft:
                self.pageControl.left = 0;
                break;
            case kTKBannerLocationCenter:
                self.pageControl.centerX = self.width/2;
                break;
            case kTKBannerLocationRight:
                self.pageControl.right = self.width;
                break;
            default:
                break;
        }
        self.pageControl.bottom =  self.height ;
    }
    _containerView.frame = self.bounds;
    
}


#pragma mark - scroll delegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self stopScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger page = scrollView.contentOffset.x/scrollView.width;
//    
//    if(_cycleShow){
//        if (page > _items.count) {
//            page = 0;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:0];
//                [self.containerView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:false];
//            });
//        }else if (page == 0){
//            page = _items.count-1;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSIndexPath *path = [NSIndexPath indexPathForItem:page+1 inSection:0];
//                [self.containerView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:false];
//            });
//        }else{
//            --page;
//        }
//    }
//    self.pageControl.currentPage = page;
//    
//    TKBannerItem *item = [self.items objectAtIndex:page];
//    _titleLabel.text = item.title;
//    [self setNeedsLayout];

    [self updatePageControl];
    [self startScroll];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    [self updatePageControl];
}


-(void)updatePageControl
{
    NSInteger page = self.containerView.contentOffset.x/self.containerView.width;
    
    if(_cycleShow){
        if (page > _items.count) {
            page = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:0];
                [self.containerView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:false];
            });
        }else if (page == 0){
            page = _items.count-1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *path = [NSIndexPath indexPathForItem:page+1 inSection:0];
                [self.containerView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:false];
            });
        }else{
            --page;
        }
    }
    self.pageControl.currentPage = page;
    
    TKBannerItem *item = [self.items objectAtIndex:page];
    _titleLabel.text = item.title;
    [self setNeedsLayout];
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_cycleShow) {
        if (self.items.count <= 1) {
            return self.items.count;
        }
        return [self.items count]+2;
    }
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_id" forIndexPath:indexPath];
    TKBannerContentView *bannerView = [cell.contentView viewWithTag:kBannerTag];
    if (bannerView == nil) {
        CGRect frame = collectionView.frame;
        frame.origin = CGPointZero;
        bannerView = [[TKBannerContentView alloc]initWithFrame:frame];
        bannerView.tag = kBannerTag;
        [cell.contentView addSubview:bannerView];
        if (self.bannerBg) {
            bannerView.bannerBlurView.image = self.bannerBg;
        }
    }
    bannerView.titleLabel.hidden = !self.titleInCell;
    bannerView.bannerBlurView.hidden = bannerView.titleLabel.hidden;
    
    if (_titleInCell) {
        bannerView.titleLabel.numberOfLines = self.titleLabel.numberOfLines;
        bannerView.titleLabel.font = self.titleLabel.font;
        bannerView.titleLabel.textColor = self.titleLabel.textColor;
        bannerView.titleLabel.textAlignment = self.titleLabel.textAlignment;
        
        self.bannerView.alpha = 1;
        self.bannerView.backgroundColor = [UIColor clearColor];
    }
    self.titleLabel.hidden = self.titleInCell;
    
    TKBannerItem *item = [self itemWithIndexPath:indexPath];
    [bannerView updateWithModel:item];
    
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKBannerItem *item = [self itemWithIndexPath:indexPath];
    return [item canTap];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    if ([self.delegate respondsToSelector:@selector(tapItem:)]) {
        TKBannerItem *item = [self itemWithIndexPath:indexPath];
        [_delegate tapItem:item];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark - 
-(TKBannerItem *)itemWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    
    if (_cycleShow) {
        
        if (indexPath.item == 0) {
            index = _items.count - 1;
        }else if (indexPath.item == _items.count + 1) {
            index = 0;
        }else{
            index = indexPath.item - 1;
        }
        
    }else{
        index = indexPath.item;
    }
    return  [self.items objectAtIndex:index];
}


@end



@implementation TKBannerContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        _bannerBlurView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bannerBlurView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bannerBlurView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        
    }
    return self;
}

-(void)updateWithModel:(TKBannerItem *)model
{
    NSURL *url = [NSURL URLWithString:model.imgUrl];
    [self.imageView sd_setImageWithURL:url placeholderImage:model.placeHolder];
    
    if (!self.titleLabel.hidden) {
        self.titleLabel.text = model.title;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.titleLabel.isHidden) {
        
        if ( self.titleLabel.numberOfLines > 1) {
            
            CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.width - 2*kHorPadding, 1000)];
            _titleLabel.size = size;
        }else{
            
            [_titleLabel sizeToFit];
        }
        
        self.titleLabel.frame =  CGRectMake(kHorPadding, self.height - 16 - _titleLabel.height,  self.width - 2*kHorPadding  , _titleLabel.height);
        
        self.bannerBlurView.top = self.height/2;
        self.bannerBlurView.height = self.height/2;
    }
}


@end


@implementation TKBannerItem

-(instancetype)init
{
    self = [super init];
    if (self) {
        _canTap = YES;
    }
    return self;
}

@end
