//
//  TKInputEmojiCollectionViewCell.m
//  ToolKit
//
//  Created by chunhui on 16/4/20.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKInputEmojiCollectionViewCell.h"
#import "TKInputEmojiManager.h"

@interface TKInputEmojiCollectionViewCell ()

@property(nonatomic , strong) UIImageView *emojiImageView;
@property(nonatomic , strong) TKInputEmojiItem *model;

@end

@implementation TKInputEmojiCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emojiImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_emojiImageView];
    }
    return self;
}

-(void)updateWithEmoji:(TKInputEmojiItem *)item
{
    self.model = item;
    self.emojiImageView.image = item.image;
}

-(TKInputEmojiItem *)emojiItem
{
    return _model;
}

@end
