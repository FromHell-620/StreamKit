//
//  UISearchBar+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (StreamSuper)

- (UISearchBar* (^)(NSInteger tag))sk_tag;

- (UISearchBar* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UISearchBar* (^)(CGRect frame))sk_frame;

- (UISearchBar* (^)(CGFloat x))sk_x;

- (UISearchBar* (^)(CGFloat y))sk_y;

- (UISearchBar* (^)(CGFloat width))sk_width;

- (UISearchBar* (^)(CGFloat height))sk_height;

- (UISearchBar* (^)(CGSize size))sk_size;

- (UISearchBar* (^)(CGRect bounds))sk_bounds;

- (UISearchBar* (^)(CGPoint point))sk_center;

- (UISearchBar* (^)(CGFloat centerX))sk_centerX;

- (UISearchBar* (^)(CGFloat centerY))sk_centerY;

- (UISearchBar* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UISearchBar* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UISearchBar* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UISearchBar* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UISearchBar* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UISearchBar* (^)(CGFloat alpha))sk_alpha;

- (UISearchBar* (^)(BOOL opaque))sk_opaque;

- (UISearchBar* (^)(BOOL hidden))sk_hidden;

- (UISearchBar* (^)(UIViewContentMode mode))sk_contentMode;

- (UISearchBar* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UISearchBar* (^)(UIColor* tintColor))sk_tintColor;

- (UISearchBar* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer;

- (UISearchBar* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer;

@end

@interface UISearchBar (StreamKit)

+ (UISearchBar* (^)(CGRect frame))sk_init;

- (UISearchBar* (^)(UIBarStyle barStyle))sk_barStyle;

- (UISearchBar* (^)(id<UISearchBarDelegate> delegate))sk_delegate;

- (UISearchBar* (^)(NSString* text))sk_text;

- (UISearchBar* (^)(NSString* prompt))sk_prompt;

- (UISearchBar* (^)(NSString* placeholder))sk_placeholder;

- (UISearchBar* (^)(BOOL showsBookmarkButton))sk_showsBookmarkButton;

- (UISearchBar* (^)(BOOL showsCancelButton))sk_showsCancelButton;

- (UISearchBar* (^)(BOOL showsSearchResultsButton))sk_showsSearchResultsButton;

- (UISearchBar* (^)(BOOL searchResultsButtonSelected))sk_searchResultsButtonSelected;

- (UISearchBar* (^)(UIColor* tintColor))sk_tintColor;

- (UISearchBar* (^)(UIColor* barTintColor))sk_barTintColor;

- (UISearchBar* (^)(UISearchBarStyle searchBarStyle))sk_searchBarStyle;

- (UISearchBar* (^)(BOOL translucent))sk_translucent;

- (UISearchBar* (^)(NSArray<NSString*>* scopeButtonTitles))sk_scopeButtonTitles;

- (UISearchBar* (^)(NSInteger selectedScopeButtonIndex))sk_selectedScopeButtonIndex;

- (UISearchBar* (^)(BOOL showsScopeBar))sk_showsScopeBar;

- (UISearchBar* (^)(UIImage* backgroundImage))sk_backgroundImage;

- (UISearchBar* (^)(UIImage* scopeBarBackgroundImage))sk_scopeBarBackgroundImage;

@end

@interface UISearchBar (StreamDelegate)

@end
