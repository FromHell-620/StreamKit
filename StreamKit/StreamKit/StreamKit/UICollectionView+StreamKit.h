//
//  UICollectionView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/27.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (StreamSuper)

#pragma mark- UIView
- (UICollectionView* (^)(NSInteger tag))sk_tag;

- (UICollectionView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UICollectionView* (^)(CGRect frame))sk_frame;

- (UICollectionView* (^)(CGFloat x))sk_x;

- (UICollectionView* (^)(CGFloat y))sk_y;

- (UICollectionView* (^)(CGFloat width))sk_width;

- (UICollectionView* (^)(CGFloat height))sk_height;

- (UICollectionView* (^)(CGSize size))sk_size;

- (UICollectionView* (^)(CGRect bounds))sk_bounds;

- (UICollectionView* (^)(CGPoint point))sk_center;

- (UICollectionView* (^)(CGFloat centerX))sk_centerX;

- (UICollectionView* (^)(CGFloat centerY))sk_centerY;

- (UICollectionView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UICollectionView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UICollectionView* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UICollectionView* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UICollectionView* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UICollectionView* (^)(CGFloat alpha))sk_alpha;

- (UICollectionView* (^)(BOOL opaque))sk_opaque;

- (UICollectionView* (^)(BOOL hidden))sk_hidden;

- (UICollectionView* (^)(UIViewContentMode mode))sk_contentMode;

- (UICollectionView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UICollectionView* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIScrollView

- (UICollectionView* (^)(CGPoint contentOffset))sk_contentOffset;

- (UICollectionView* (^)(CGPoint contentOffset,BOOL animated))sk_contentOffsetWithAnimated;

- (UICollectionView* (^)(CGSize contentSize))sk_contentSize;

- (UICollectionView* (^)(UIEdgeInsets contentInset))sk_contentInset;

- (UICollectionView* (^)(BOOL directionalLockEnabled))sk_directionalLockEnabled;

- (UICollectionView* (^)(BOOL bounces))sk_bounces;

- (UICollectionView* (^)(BOOL alwaysBounceVertical))sk_alwaysBounceVertical;

- (UICollectionView* (^)(BOOL alwaysBounceHorizontal))sk_alwaysBounceHorizontal;

- (UICollectionView* (^)(BOOL pagingEnabled))sk_pagingEnabled;

- (UICollectionView* (^)(BOOL scrollEnabled))sk_scrollEnabled;

- (UICollectionView* (^)(BOOL showsHorizontalScrollIndicator))sk_showsHorizontalScrollIndicator;

- (UICollectionView* (^)(BOOL showsVerticalScrollIndicator))sk_showsVerticalScrollIndicator;

- (UICollectionView* (^)(UIEdgeInsets scrollIndicatorInsets))sk_scrollIndicatorInsets;

- (UICollectionView* (^)(CGFloat minimumZoomScale))sk_minimumZoomScale;

- (UICollectionView* (^)(CGFloat maximumZoomScale))sk_maximumZoomScale;

- (UICollectionView* (^)(CGFloat zoomScale))sk_zoomScale;

- (UICollectionView* (^)(CGFloat zoomScale,BOOL animated))sk_zoomScaleWithAnimated;

- (UICollectionView* (^)(BOOL bouncesZoom))sk_bouncesZoom;

- (UICollectionView* (^)(BOOL scrollsToTop))sk_scrollsToTop;

@end

@interface UICollectionView (StreamKit)

+ (UICollectionView* (^)(CGRect frame,UICollectionViewLayout* layout))sk_initWithFrameAndLayout;

- (UICollectionView* (^)(UICollectionViewLayout* layout))sk_collectionViewLayout;

- (UICollectionView* (^)(id<UICollectionViewDelegate> delegate))sk_delegate;

- (UICollectionView* (^)(id<UICollectionViewDataSource> dataSource))sk_dataSource;

- (UICollectionView* (^)(Class cellClass,NSString* identifier))sk_registerClassForCellWithReuseIdentifier;

- (UICollectionView* (^)(UINib* nib,NSString* identifier))sk_registerNibForCellWithReuseIdentifier;

- (UICollectionView* (^)(Class viewClass,NSString* elementKind,NSString* identifier))sk_registerClassForSupplementaryViewOfKind;

- (UICollectionView* (^)(UINib* viewNib,NSString* elementKind,NSString* identifier))sk_registerNibForSupplementaryViewOfKind;

@end

@interface UICollectionViewFlowLayout (StreamKit)

- (UICollectionViewFlowLayout* (^)(CGFloat minimumLineSpacing))sk_minimumLineSpacing;

- (UICollectionViewFlowLayout* (^)(CGFloat minimumInteritemSpacing))sk_minimumInteritemSpacing;

- (UICollectionViewFlowLayout* (^)(CGSize itemSize))sk_itemSize;

- (UICollectionViewFlowLayout* (^)(CGSize estimatedItemSize))sk_estimatedItemSize NS_AVAILABLE_IOS(8_0);

- (UICollectionViewFlowLayout* (^)(UICollectionViewScrollDirection scrollDirection))sk_scrollDirection;

- (UICollectionViewFlowLayout* (^)(CGSize headerReferenceSize))sk_headerReferenceSize;

- (UICollectionViewFlowLayout* (^)(CGSize footerReferenceSize))sk_footerReferenceSize;

- (UICollectionViewFlowLayout* (^)(UIEdgeInsets sectionInset))sk_sectionInset;

@end

