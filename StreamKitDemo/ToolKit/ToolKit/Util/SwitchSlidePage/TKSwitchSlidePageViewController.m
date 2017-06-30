//
//  TKSwitchSlidePageViewController.m
//  ToolKit
//
//  Created by chunhui on 16/3/31.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKSwitchSlidePageViewController.h"
#import "TKSwitchSlideView.h"
#import "UIView+Utils.h"


@interface TKSwitchSlidePageViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property(nonatomic , strong) TKSwitchSlideView *slideView;
@property(nonatomic , strong) UICollectionView *contentView;


@property(nonatomic , strong) NSMutableDictionary *visibleControllerDict;
@property(nonatomic , strong) NSMutableDictionary *cacheControllerDict;

@end

@implementation TKSwitchSlidePageViewController

-(void)initItems
{
    _visibleControllerDict = [NSMutableDictionary new];
    _cacheControllerDict = [NSMutableDictionary new];
    
}

-(void)initViews
{
    __weak typeof(self) wself = self;
    _slideView = [[TKSwitchSlideView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _slideSwitchHeight) cellClass:self.slideItemClass edgeInsets:_slideEdgeInsets];
    _slideView.chooseItem = ^(NSInteger index){
        
        NSInteger currentIndex = (NSInteger)(wself.contentView.contentOffset.x/wself.contentView.width);
        if (index == currentIndex) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *controller = [wself showedControllerForIndex:indexPath];
            [wself.delegate tapCurrentItem:index controller:controller];
            
        }else{
            
            [wself selectedAtIndex:index animated:false];
        }
    };
    [self.view addSubview:_slideView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _contentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _slideView.bottom, SCREEN_WIDTH, self.view.height - _slideView.bottom) collectionViewLayout:layout];
//    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    _contentView.contentInset = UIEdgeInsetsZero;
    _contentView.showsHorizontalScrollIndicator = false;
    _contentView.showsVerticalScrollIndicator = false;
    _contentView.scrollsToTop = false;
    _contentView.pagingEnabled = true;
    
    _contentView.backgroundColor = [UIColor whiteColor];
    
    [_contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_contentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self initItems];
    [self initViews];
    
    
    NSArray *titles = [_delegate pageTitles];
    [_slideView updateWithItems:titles];
    
    
    [self initCaches];
    [_slideView selectAtIndex:0];
    
}

- (void)setSlideBackgroundColor:(UIColor *)slideBackgroundColor
{
    _slideView.slideBackgroundColor = slideBackgroundColor;
}

-(NSInteger)currentSelectIndex
{
    return [_slideView currentSelectIndex];
}

-(void)selectedAtIndex:(NSInteger)index
{
    [self selectedAtIndex:index animated:true];
}
-(void)selectedAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= [_delegate numberofPages]) {
        return;
    }
    
    [self.slideView selectAtIndex:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.contentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    [self.contentView reloadItemsAtIndexPaths:@[indexPath]];
    
}

-(NSInteger)currentIndex
{
    return (NSInteger)(_contentView.contentOffset.x/_contentView.width);
}

- (UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *)currentShowController
{
    NSInteger index = [self currentIndex];
    UIViewController *controller = [self showedControllerForIndex:[NSIndexPath indexPathForItem:index inSection:0]];
    return controller;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)initCaches
{
    UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *controller = nil;
    
    for (int i = 0 ; i < MIN(3, [_delegate numberofPages]); ++i) {
        controller = [_delegate controllerForIndex:i];
        _cacheControllerDict[@(i)] = controller;
    }
}

-(void)handleWillDisappear:(NSIndexPath *)indexPath
{
    NSNumber *key = @(indexPath.item);
    UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *controller = _visibleControllerDict[key];
    
    if (controller) {
        
        [_visibleControllerDict removeObjectForKey:key];
        
        _cacheControllerDict[key] = controller;
        
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
        [controller pageWillPurge];
    }
    
}

-(UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *)showedControllerForIndex:(NSIndexPath *)indexPath
{
    NSNumber *key = @(indexPath.item);
    UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *controller = _visibleControllerDict[key];
    if (controller) {
        return controller;
    }
    
    controller = _cacheControllerDict[key];
    if (controller) {
        return controller;
    }
    
    NSArray *allkeys = [_cacheControllerDict allKeys];
    allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        //升序排列
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    
    NSNumber *removeKey = nil;
    if (indexPath.item < [[allkeys firstObject] integerValue]) {
        removeKey = [allkeys lastObject];
    }else{
        removeKey = [allkeys firstObject];
    }
    
    controller = _cacheControllerDict[removeKey];
    [_cacheControllerDict removeObjectForKey:removeKey];
    _cacheControllerDict[key] = controller;
    
    //若controller还未显示就被复用，需要提前设置起frame
    controller.view.frame = self.contentView.bounds;
    
    [_delegate willReuseController:controller forIndex:indexPath.item];
    
    return controller;
}

- (void)reload
{
    for(UIViewController *vc in _cacheControllerDict.allValues) {
        [vc removeFromParentViewController];
    }
    [_cacheControllerDict removeAllObjects];
    
    for (UIViewController *vc in _visibleControllerDict.allValues) {
        [vc removeFromParentViewController];
    }
    [_visibleControllerDict removeAllObjects];
    
    [self initCaches];
    
    [self.contentView reloadData];
    
    [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    
    NSArray *titles = [_delegate pageTitles];
    [_slideView updateWithItems:titles];
    
    [_slideView selectAtIndex:0];
}

- (void)updateSlideViewFrame:(CGFloat)topOffset
{
    self.slideView.frame = CGRectMake(0, topOffset, self.view.width, self.slideSwitchHeight);    
}

- (void)updateCollectionViewFrame:(CGFloat)disToBottom
{
    CGFloat height = self.view.height - self.slideView.bottom - disToBottom ;
    if (self.view.top > 10 && self.view.top < 64 ) {
        height = SCREEN_HEIGHT - disToBottom - 64 - self.slideView.bottom;
    }
    self.contentView.frame = CGRectMake(0, self.slideView.bottom, self.view.width, height);
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.contentView reloadData];
    });
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_delegate numberofPages];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *controller = [self showedControllerForIndex:indexPath];
    
    controller.view.frame = cell.contentView.bounds;
    NSArray *subviews = [cell.contentView subviews];
    if (subviews.count > 0) {
        
        [subviews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    [cell.contentView addSubview:controller.view];
    
    if (!collectionView.isDragging) {
        [controller pageWillShow];
    }
    
    
    return  cell;
}

#pragma mark - collection layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleWillDisappear:indexPath];
    
    NSInteger item = collectionView.contentOffset.x / collectionView.width;
    
    if (_isAllowGradualChange) {
        if (collectionView.contentOffset.x == collectionView.width * item) {
            [_slideView selectAtIndex:item];
        }
    }else{
        [_slideView selectAtIndex:item];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isAllowGradualChange) {
        NSInteger item = _contentView.contentOffset.x / _contentView.width;
        
        CGFloat offset = _contentView.contentOffset.x - _contentView.width * item;
        
        
        CGFloat alpha1 = 1 - offset/_contentView.width;
        CGFloat alpha2 = offset/_contentView.width;
        
        //第一个或者最后一个的时候不调节渐变
        if (_contentView.contentOffset.x > 0  && item + 1 < _contentView.contentSize.width / _contentView.width) {
            [_slideView adjustCellAtIndex:item offset:alpha1];
            [_slideView adjustCellAtIndex:item + 1 offset:alpha2];
        }
        
        if (item - 1 > 0) {
            [_slideView adjustCellAtIndex:item - 1 offset:0];
        }
        
        if (item + 2 < _contentView.contentSize.width / _contentView.width) {
            [_slideView adjustCellAtIndex:item + 2 offset:0];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //待停止时加载数据
    [self.contentView reloadData];
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
