//
//  TKSwitchSlideView.m
//  ToolKit
//
//  Created by chunhui on 16/3/31.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKSwitchSlideView.h"
#import "TKSwitchSlideItemCollectionViewCell.h"
#import "UIView+Utils.h"

@interface TKSwitchSlideView ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property(nonnull , strong) UICollectionView *scrollView;
@property(nonatomic , strong) NSMutableArray *titles;
@property(nonatomic , strong) Class itemCellClass;
@property(nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation TKSwitchSlideView

-(instancetype)initWithFrame:(CGRect)frame cellClass:(Class) cellClass
{
    return [self initWithFrame:frame cellClass:cellClass edgeInsets:UIEdgeInsetsZero];
}

-(instancetype)initWithFrame:(CGRect)frame cellClass:(Class) cellClass edgeInsets:(UIEdgeInsets)edgeInsets
{
    self = [super initWithFrame: frame];
    if (self) {
        _edgeInsets = edgeInsets;
        self.itemCellClass = cellClass;
        if (cellClass == nil ){
            self.itemCellClass = [TKSwitchSlideItemCollectionViewCell class];
        }
        [self addSubview:self.scrollView];
        _titles = [[NSMutableArray alloc]init];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(UICollectionView *)scrollView
{
    if (!_scrollView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _scrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(_edgeInsets.left, _edgeInsets.top, self.size.width - _edgeInsets.left - _edgeInsets.right, self.size.height - _edgeInsets.top - _edgeInsets.bottom) collectionViewLayout:layout];
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        _scrollView.contentInset = UIEdgeInsetsZero;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.scrollsToTop = false;
        _scrollView.allowsMultipleSelection = false;
        _scrollView.allowsSelection = true;
        
        [_scrollView registerClass:self.itemCellClass forCellWithReuseIdentifier:@"cell"];
        
    }
    return _scrollView;
}

- (void)setSlideBackgroundColor:(UIColor *)slideBackgroundColor
{
    _scrollView.backgroundColor = slideBackgroundColor;
}

-(void)updateWithItems:(NSArray<NSString *> *)itemTitles
{
    [self.titles removeAllObjects];
    [self.titles addObjectsFromArray:itemTitles];
    
    [_scrollView reloadData];
    [_scrollView layoutIfNeeded];
}

-(void)selectAtIndex:(NSInteger)index
{
    if (index < 0 || index > [_titles count]) {
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self scrollItemToFit:path];
    __weak typeof (self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself.scrollView selectItemAtIndexPath:path animated:true scrollPosition:UICollectionViewScrollPositionNone];
    });
}

-(void)adjustCellAtIndex:(NSInteger)index offset:(CGFloat)offset
{
    TKSwitchSlideItemCollectionViewCell *cell = [_scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    [cell updateWithOffset:offset];
}

-(NSInteger)currentSelectIndex
{
    NSArray<NSIndexPath *> *indexPaths = [_scrollView indexPathsForSelectedItems];
    if ([indexPaths count] > 0) {
        return [[indexPaths firstObject] item];
    }
    return -1;
}

-(void)scrollItemToFit:(NSIndexPath *)itemPath
{
    CGFloat offsetx = 0;
    for (NSInteger i = 0 ; i < itemPath.item; i++) {
        offsetx += [self collectionView:_scrollView layout:_scrollView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]].width;
    }
    
    CGFloat width =  [self collectionView:_scrollView layout:_scrollView.collectionViewLayout sizeForItemAtIndexPath:itemPath].width;
    if (offsetx < _scrollView.contentOffset.x) {
        [_scrollView scrollToItemAtIndexPath:itemPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
    }else if (offsetx + width > _scrollView.contentOffset.x + _scrollView.width){
        [_scrollView scrollToItemAtIndexPath:itemPath atScrollPosition:UICollectionViewScrollPositionRight animated:true];
    }
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [_titles count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TKSwitchSlideItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell updateWithTitle:_titles[indexPath.item]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectAtIndex:indexPath.item];
    if (self.chooseItem) {
        self.chooseItem(indexPath.item);
    }
}

#pragma mark - flow layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = _titles[indexPath.item];
    
    CGFloat width = [self.itemCellClass cellWidthForTitle:title];
    
    return CGSizeMake(width, collectionView.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsZero;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
