//
//  UICollectionView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/27.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
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

/**
 Creates a new collectionView by the given block.
 @code
 UICollectionView* collectionView = UICollectionView.sk_initWithFrameAndLayout(frame,layout);
 @endcode
 */
+ (UICollectionView* (^)(CGRect frame,UICollectionViewLayout* layout))sk_initWithFrameAndLayout;

/**
 Set layout.
 */
- (UICollectionView* (^)(UICollectionViewLayout* layout))sk_collectionViewLayout;

/**
 Set delegate.
 */
- (UICollectionView* (^)(id<UICollectionViewDelegate> delegate))sk_delegate;

/**
 Set dataSource.
 */
- (UICollectionView* (^)(id<UICollectionViewDataSource> dataSource))sk_dataSource;

/**
 Register class cell with  cellClass and identifier.
 @code
 self.sk_registerClassForCellWithReuseIdentifier(cellClass,identifier);
 @endcode
 */
- (UICollectionView* (^)(Class cellClass,NSString* identifier))sk_registerClassForCellWithReuseIdentifier;

/**
 Register nib cell with nib and identifier.
 @code
 self.sk_registerNibForCellWithReuseIdentifier(nib,identifier);
 @endcode
 */
- (UICollectionView* (^)(UINib* nib,NSString* identifier))sk_registerNibForCellWithReuseIdentifier;

/**
 Register SupplementaryView.
 @code
 self.sk_registerClassForSupplementaryViewOfKind(viewClass,elementKind,identifier);
 @endcode
 */
- (UICollectionView* (^)(Class viewClass,NSString* elementKind,NSString* identifier))sk_registerClassForSupplementaryViewOfKind;

/**
 Register SupplementaryView.
 @code
 self.sk_registerNibForSupplementaryViewOfKind(viewNib,elementKind,identifier);
 @endcode
 */
- (UICollectionView* (^)(UINib* viewNib,NSString* elementKind,NSString* identifier))sk_registerNibForSupplementaryViewOfKind;

@end

@interface UICollectionViewFlowLayout (StreamKit)

/**
 Set minimumLineSpacing.
 */
- (UICollectionViewFlowLayout* (^)(CGFloat minimumLineSpacing))sk_minimumLineSpacing;

/**
 Set minimumInteritemSpacing.
 */
- (UICollectionViewFlowLayout* (^)(CGFloat minimumInteritemSpacing))sk_minimumInteritemSpacing;

/**
 Set itemSize.
 */
- (UICollectionViewFlowLayout* (^)(CGSize itemSize))sk_itemSize;

/**
 Set estimatedItemSize.
 */
- (UICollectionViewFlowLayout* (^)(CGSize estimatedItemSize))sk_estimatedItemSize NS_AVAILABLE_IOS(8_0);

/**
 Set scrollDirection.
 */
- (UICollectionViewFlowLayout* (^)(UICollectionViewScrollDirection scrollDirection))sk_scrollDirection;

/**
 Set headerReferenceSize.
 */
- (UICollectionViewFlowLayout* (^)(CGSize headerReferenceSize))sk_headerReferenceSize;

/**
 Set footerReferenceSize.
 */
- (UICollectionViewFlowLayout* (^)(CGSize footerReferenceSize))sk_footerReferenceSize;

/**
 Set sectionInset.
 */
- (UICollectionViewFlowLayout* (^)(UIEdgeInsets sectionInset))sk_sectionInset;

@end

