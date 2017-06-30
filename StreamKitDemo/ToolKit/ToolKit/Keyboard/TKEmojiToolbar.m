//
//  TKEmojiToolbar.m
//  ToolKit
//
//  Created by chunhui on 16/4/20.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKEmojiToolbar.h"
#import "UIView+Utils.h"

#define kSendWidth 50

@interface TKEmojiToolbarCollectionViewCell : UICollectionViewCell

@property(nonatomic , strong) UIImageView *icon;
@property(nonatomic , strong) UIView *splitLine;

@end

@interface TKEmojiToolbar()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic , strong) UIButton *sendButton;
@property(nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic , strong) NSArray *icons;

@end

@implementation TKEmojiToolbar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.frame = CGRectMake(self.width - kSendWidth, 0, kSendWidth, self.height);
        
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        
        [self addSubview:_sendButton];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(60, self.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width - kSendWidth, self.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[TKEmojiToolbarCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionView];
        
    }
    return self;
}

-(void)setSendBgColor:(UIColor *)sendBgColor
{    
    if (sendBgColor) {
        self.sendButton.backgroundColor = sendBgColor;
    }
}

-(UIColor *)sendBgColor
{
    return self.sendButton.backgroundColor;
}

-(void)updateWithIcons:(NSArray *)icons
{
    self.icons = icons;
    [self.collectionView reloadData ];
    if ([icons count] > 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionLeft];
    }
}

-(void)sendAction:(id)sender
{
    if (_sendBlock) {
        _sendBlock();
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.icons count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKEmojiToolbarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView * iconImage = [cell.contentView viewWithTag:111];
    if (iconImage == nil) {
        iconImage = [[UIImageView alloc]init];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        iconImage.frame = cell.contentView.bounds;
        iconImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        iconImage.tag = 111;
        [cell.contentView addSubview:iconImage];
    }
    
    cell.icon.image = _icons[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chooseAtIndex) {
        self.chooseAtIndex(indexPath.item);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation  TKEmojiToolbarCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc]initWithFrame:self.bounds];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, self.height)];
        _splitLine.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_splitLine];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _icon.center = CGPointMake(self.width/2, self.height/2);
    _splitLine.frame = CGRectMake(self.width-0.5, 5, 0.5, self.height - 10);
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.contentView.backgroundColor = selected ? [UIColor lightGrayColor] :[UIColor whiteColor];
}

@end
