//
//  UITextView+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/23.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UITextView (StreamSuper)

#pragma mark- UIView
- (UITextView* (^)(NSInteger tag))sk_tag;

- (UITextView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UITextView* (^)(CGRect frame))sk_frame;

- (UITextView* (^)(CGFloat x))sk_x;

- (UITextView* (^)(CGFloat y))sk_y;

- (UITextView* (^)(CGFloat width))sk_width;

- (UITextView* (^)(CGFloat height))sk_height;

- (UITextView* (^)(CGSize size))sk_size;

- (UITextView* (^)(CGRect bounds))sk_bounds;

- (UITextView* (^)(CGPoint point))sk_center;

- (UITextView* (^)(CGFloat centerX))sk_centerX;

- (UITextView* (^)(CGFloat centerY))sk_centerY;

- (UITextView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UITextView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UITextView* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UITextView* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UITextView* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UITextView* (^)(CGFloat alpha))sk_alpha;

- (UITextView* (^)(BOOL opaque))sk_opaque;

- (UITextView* (^)(BOOL hidden))sk_hidden;

- (UITextView* (^)(UIViewContentMode mode))sk_contentMode;

- (UITextView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UITextView* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIScrollView

- (UITextView* (^)(CGPoint contentOffset))sk_contentOffset;

- (UITextView* (^)(CGPoint contentOffset,BOOL animated))sk_contentOffsetWithAnimated;

- (UITextView* (^)(CGSize contentSize))sk_contentSize;

- (UITextView* (^)(UIEdgeInsets contentInset))sk_contentInset;

- (UITextView* (^)(BOOL directionalLockEnabled))sk_directionalLockEnabled;

- (UITextView* (^)(BOOL bounces))sk_bounces;

- (UITextView* (^)(BOOL alwaysBounceVertical))sk_alwaysBounceVertical;

- (UITextView* (^)(BOOL alwaysBounceHorizontal))sk_alwaysBounceHorizontal;

- (UITextView* (^)(BOOL pagingEnabled))sk_pagingEnabled;

- (UITextView* (^)(BOOL scrollEnabled))sk_scrollEnabled;

- (UITextView* (^)(BOOL showsHorizontalScrollIndicator))sk_showsHorizontalScrollIndicator;

- (UITextView* (^)(BOOL showsVerticalScrollIndicator))sk_showsVerticalScrollIndicator;

- (UITextView* (^)(UIEdgeInsets scrollIndicatorInsets))sk_scrollIndicatorInsets;

- (UITextView* (^)(CGFloat minimumZoomScale))sk_minimumZoomScale;

- (UITextView* (^)(CGFloat maximumZoomScale))sk_maximumZoomScale;

- (UITextView* (^)(CGFloat zoomScale))sk_zoomScale;

- (UITextView* (^)(CGFloat zoomScale,BOOL animated))sk_zoomScaleWithAnimated;

- (UITextView* (^)(BOOL bouncesZoom))sk_bouncesZoom;

- (UITextView* (^)(BOOL scrollsToTop))sk_scrollsToTop;


@end

@interface UITextView (StreamKit)

/**
 Creates a new textView by the given block which receive a frame.
 */
+ (UITextView* (^)(CGRect frame))sk_initWithFrame;

/**
 Creates a new textView by the given block which receive a frame and a container.
 */
+ (UITextView* (^)(CGRect frame,NSTextContainer* container))sk_initWithFrameAndContainer;

/**
 Set delegate.
 */
- (UITextView* (^)(id<UITextViewDelegate> delegate))sk_delegate;

/**
 Set text.
 */
- (UITextView* (^)(NSString* text))sk_text;

/**
 Set font.
 */
- (UITextView* (^)(UIFont* font))sk_font;

/**
 Set font.
 */
- (UITextView* (^)(NSInteger fontSize))sk_fontSize;

/**
 Set textColor.
 */
- (UITextView* (^)(UIColor* textColor))sk_textColor;

/**
 Set textAlignment.
 */
- (UITextView* (^)(NSTextAlignment textAlignment))sk_textAlignment;

/**
 Set selectedRange.
 */
- (UITextView* (^)(NSRange selectedRange))sk_selectedRange;

/**
 Set editable.
 */
- (UITextView* (^)(BOOL editable))sk_editable;

/**
 Set selectable.
 */
- (UITextView* (^)(BOOL selectable))sk_selectable;

/**
 Set dataDetectorTypes.
 */
- (UITextView* (^)(UIDataDetectorTypes dataDetectorTypes))sk_dataDetectorTypes;

/**
 Set allowsEditingTextAttributes.
 */
- (UITextView* (^)(BOOL allowsEditingTextAttributes))sk_allowsEditingTextAttributes;

/**
 Set attributedText.
 */
- (UITextView* (^)(NSAttributedString* attributedText))sk_attributedText;

/**
 Set typingAttributes.
 */
- (UITextView* (^)(NSDictionary<NSString*,id>* typingAttributes))sk_typingAttributes;

/**
 Set inputView
 */
- (UITextView* (^)(UIView* inputView))sk_inputView;

/**
 Set inputAccessoryView.
 */
- (UITextView* (^)(UIView* inputAccessoryView))sk_inputAccessoryView;

/**
 Set clearsOnInsertion.
 */
- (UITextView* (^)(BOOL clearsOnInsertion))sk_clearsOnInsertion;

/**
 Set textContainerInset.
 */
- (UITextView* (^)(UIEdgeInsets textContainerInset))sk_textContainerInset;

/**
 Set linkTextAttributes.
 */
- (UITextView* (^)(NSDictionary<NSString*,id>* linkTextAttributes))sk_linkTextAttributes;

@end

@interface UITextView (StreamDelegate)

/**
 Instead of the 'textViewShouldBeginEditing:'.
 */
- (UITextView* (^)(BOOL(^block)(UITextView* textView)))sk_textViewShouldBeginEditing;

/**
 Instead of the 'textViewShouldEndEditing:'.
 */
- (UITextView* (^)(BOOL(^block)(UITextView* textView)))sk_textViewShouldEndEditing;

/**
 Instead of the 'textViewDidBeginEditing:'.
 */
- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidBeginEditing;

/**
 Instead of the 'textViewDidEndEditing:'.
 */
- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidEndEditing;

/**
 Instead of the 'textView:shouldChangeTextInRange:replacementText:'.
 */
- (UITextView* (^)(void(^block)(UITextView* textView,NSRange range,NSString* string)))sk_textViewShouldChangeTextInRange;

/**
 Instead of the 'textViewDidChange:'.
 */
- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidChange;

/**
 Instead of the 'textViewDidChangeSelection:'.
 */
- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidChangeSelection;


@end
