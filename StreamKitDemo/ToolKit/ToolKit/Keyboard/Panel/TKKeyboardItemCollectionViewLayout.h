//
//  TKKeyboardItemCollectionViewLayout.h
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKKeyboardItemCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGSize       itemSize;
@property (nonatomic) CGFloat      lineSpacing;
@property (nonatomic) CGFloat      itemSpacing;
@property (nonatomic) UIEdgeInsets pageContentInsets;

@end
