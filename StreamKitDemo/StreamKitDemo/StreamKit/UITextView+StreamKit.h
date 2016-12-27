//
//  UITextView+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/23.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

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

+ (UITextView* (^)(CGRect frame))sk_initWithFrame;

+ (UITextView* (^)(CGRect frame,NSTextContainer* container))sk_initWithFrameAndContainer;

- (UITextView* (^)(id<UITextViewDelegate> delegate))sk_delegate;

- (UITextView* (^)(NSString* text))sk_text;

- (UITextView* (^)(UIFont* font))sk_font;

- (UITextView* (^)(NSInteger fontSize))sk_fontSize;

- (UITextView* (^)(UIColor* textColor))sk_textColor;

- (UITextView* (^)(NSTextAlignment textAlignment))sk_textAlignment;

- (UITextView* (^)(NSRange selectedRange))sk_selectedRange;

- (UITextView* (^)(BOOL editable))sk_editable;

- (UITextView* (^)(BOOL selectable))sk_selectable;

- (UITextView* (^)(UIDataDetectorTypes dataDetectorTypes))sk_dataDetectorTypes;

- (UITextView* (^)(BOOL allowsEditingTextAttributes))sk_allowsEditingTextAttributes;

- (UITextView* (^)(NSAttributedString* attributedText))sk_attributedText;

- (UITextView* (^)(NSDictionary<NSString*,id>* typingAttributes))sk_typingAttributes;

- (UITextView* (^)(UIView* inputView))sk_inputView;

- (UITextView* (^)(UIView* inputAccessoryView))sk_inputAccessoryView;

- (UITextView* (^)(BOOL clearsOnInsertion))sk_clearsOnInsertion;

- (UITextView* (^)(UIEdgeInsets textContainerInset))sk_textContainerInset;

- (UITextView* (^)(NSDictionary<NSString*,id>* linkTextAttributes))sk_linkTextAttributes;

@end

@interface UITextView (StreamDelegate)

- (UITextView* (^)(BOOL(^block)(UITextView* textView)))sk_textViewShouldBeginEditing;

- (UITextView* (^)(BOOL(^block)(UITextView* textView)))sk_textViewShouldEndEditing;

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidBeginEditing;

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidEndEditing;

- (UITextView* (^)(void(^block)(UITextView* textView,NSRange range,NSString* string)))sk_textViewShouldChangeTextInRange;

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidChange;

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidChangeSelection;


@end
