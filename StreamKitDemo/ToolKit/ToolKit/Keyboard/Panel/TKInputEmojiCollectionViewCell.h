//
//  TKInputEmojiCollectionViewCell.h
//  ToolKit
//
//  Created by chunhui on 16/4/20.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKInputEmojiItem;

@interface TKInputEmojiCollectionViewCell : UICollectionViewCell


-(void)updateWithEmoji:(TKInputEmojiItem *)item;

-(TKInputEmojiItem *)emojiItem;

@end
