//
//  UITableView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/26.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UITableView (StreamSuper)

#pragma mark- UIView
- (UITableView* (^)(NSInteger tag))sk_tag;

- (UITableView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UITableView* (^)(CGRect frame))sk_frame;

- (UITableView* (^)(CGFloat x))sk_x;

- (UITableView* (^)(CGFloat y))sk_y;

- (UITableView* (^)(CGFloat width))sk_width;

- (UITableView* (^)(CGFloat height))sk_height;

- (UITableView* (^)(CGSize size))sk_size;

- (UITableView* (^)(CGRect bounds))sk_bounds;

- (UITableView* (^)(CGPoint point))sk_center;

- (UITableView* (^)(CGFloat centerX))sk_centerX;

- (UITableView* (^)(CGFloat centerY))sk_centerY;

- (UITableView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UITableView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UITableView* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UITableView* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UITableView* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UITableView* (^)(CGFloat alpha))sk_alpha;

- (UITableView* (^)(BOOL opaque))sk_opaque;

- (UITableView* (^)(BOOL hidden))sk_hidden;

- (UITableView* (^)(UIViewContentMode mode))sk_contentMode;

- (UITableView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UITableView* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIScrollView

- (UITableView* (^)(CGPoint contentOffset))sk_contentOffset;

- (UITableView* (^)(CGPoint contentOffset,BOOL animated))sk_contentOffsetWithAnimated;

- (UITableView* (^)(CGSize contentSize))sk_contentSize;

- (UITableView* (^)(UIEdgeInsets contentInset))sk_contentInset;

- (UITableView* (^)(BOOL directionalLockEnabled))sk_directionalLockEnabled;

- (UITableView* (^)(BOOL bounces))sk_bounces;

- (UITableView* (^)(BOOL alwaysBounceVertical))sk_alwaysBounceVertical;

- (UITableView* (^)(BOOL alwaysBounceHorizontal))sk_alwaysBounceHorizontal;

- (UITableView* (^)(BOOL pagingEnabled))sk_pagingEnabled;

- (UITableView* (^)(BOOL scrollEnabled))sk_scrollEnabled;

- (UITableView* (^)(BOOL showsHorizontalScrollIndicator))sk_showsHorizontalScrollIndicator;

- (UITableView* (^)(BOOL showsVerticalScrollIndicator))sk_showsVerticalScrollIndicator;

- (UITableView* (^)(UIEdgeInsets scrollIndicatorInsets))sk_scrollIndicatorInsets;

- (UITableView* (^)(CGFloat minimumZoomScale))sk_minimumZoomScale;

- (UITableView* (^)(CGFloat maximumZoomScale))sk_maximumZoomScale;

- (UITableView* (^)(CGFloat zoomScale))sk_zoomScale;

- (UITableView* (^)(CGFloat zoomScale,BOOL animated))sk_zoomScaleWithAnimated;

- (UITableView* (^)(BOOL bouncesZoom))sk_bouncesZoom;

- (UITableView* (^)(BOOL scrollsToTop))sk_scrollsToTop;

@end

@interface UITableView (StreamKit)

/**
 Creates a new tableView by the given frame.And the style is 'UITableViewStylePlain'.
 @code
 UITableView* tableView = UITableView.sk_initWithFrame(frame);
 @endcode
 */
+ (UITableView* (^)(CGRect frame))sk_initWithFrame;

/**
 Creates a new tableView by the given block which receive a frame and a style.
 @code
 UITableView* tableView = UITableView.sk_initWithFrameAndStyle(frame,style);
 @endcode
 */
+ (UITableView* (^)(CGRect frame,UITableViewStyle style))sk_initWithFrameAndStyle;

/**
 Set dataSource.
 */
- (UITableView* (^)(id<UITableViewDataSource> dataSource))sk_dataSource;

/**
 Set delegate.
 */
- (UITableView* (^)(id<UITableViewDelegate> delegate))sk_delegate;

/**
 Set prefetchDataSource.
 */
- (UITableView* (^)(id<UITableViewDataSourcePrefetching> prefetchDataSource))sk_prefetchDataSource NS_AVAILABLE_IOS(10_0);

/**
 Set rowHeight.
 */
- (UITableView* (^)(CGFloat rowHeight))sk_rowHeight;

/**
 Set sectionHeaderHeight.
 */
- (UITableView* (^)(CGFloat sectionHeaderHeight))sk_sectionHeaderHeight;

/**
 Set sectionFooterHeight.
 */
- (UITableView* (^)(CGFloat sectionFooterHeight))sk_sectionFooterHeight;

/**
 Set estimatedRowHeight.
 */
- (UITableView* (^)(CGFloat estimatedRowHeight))sk_estimatedRowHeight NS_AVAILABLE_IOS(7_0);

/**
 Set estimatedSectionHeaderHeight.
 */
- (UITableView* (^)(CGFloat estimatedSectionHeaderHeight))sk_estimatedSectionHeaderHeight NS_AVAILABLE_IOS(7_0);

/**
 Set estimatedSectionFooterHeight.
 */
- (UITableView* (^)(CGFloat estimatedSectionFooterHeight))sk_estimatedSectionFooterHeight NS_AVAILABLE_IOS(7_0);

/**
 Set separatorInset.
 */
- (UITableView* (^)(UIEdgeInsets separatorInset))sk_separatorInset NS_AVAILABLE_IOS(7_0);

/**
 Set backgroundView.
 */
- (UITableView* (^)(UIView* backgroundView))sk_backgroundView;

/**
 Set separatorStyle.
 */
- (UITableView* (^)(UITableViewCellSeparatorStyle separatorStyle))sk_separatorStyle;

/**
 Set tableHeaderView.
 */
- (UITableView* (^)(UIView* tableHeaderView))sk_tableHeaderView;

/**
 Set tableFooterView.
 */
- (UITableView* (^)(UIView* tableFooterView))sk_tableFooterView;

/**
 Register cell with class.
 */
- (UITableView* (^)(Class cellClass,NSString* identifier))sk_registerClassForCellReuseIdentifier;

/**
 Register cell with nib.
 */
- (UITableView* (^)(UINib* nib,NSString* identifier))sk_registerNibForCellReuseIdentifier;

/**
 Register HeaderFooterView with class.
 */
- (UITableView* (^)(Class viewClass,NSString* identifier))sk_registerClassForHeaderFooterViewReuseIdentifier;

/**
 Register HeaderFooterView with nib.
 */
- (UITableView* (^)(UINib* nib,NSString* identifier))sk_registerNibForHeaderFooterViewReuseIdentifier;

@end

@interface UITableViewCell (StreamKit)

/**
 Creates a new tableViewCell.
 */
+ (UITableViewCell* (^)(UITableViewCellStyle cellStyle,NSString* reuseIdentifier))sk_initWithStyleAndReuseIdentifier;

/**
 Set selectionStyle.
 */
- (UITableViewCell* (^)(UITableViewCellSelectionStyle selectionStyle))sk_selectionStyle;

/**
 Set accessoryType.
 */
- (UITableViewCell* (^)(UITableViewCellAccessoryType accessoryType))sk_accessoryType;

/**
 Set editingAccessoryType.
 */
- (UITableViewCell* (^)(UITableViewCellAccessoryType editingAccessoryType))sk_editingAccessoryType;

@end
