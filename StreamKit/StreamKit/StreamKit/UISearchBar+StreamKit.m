//
//  UISearchBar+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UISearchBar+StreamKit.h"

@implementation UISearchBar (StreamKit)

+ (UISearchBar* (^)(CGRect frame))sk_init
{
    return ^ UISearchBar* (CGRect frame) {
        return [[UISearchBar alloc] initWithFrame:frame];
    };
}

- (UISearchBar* (^)(UIBarStyle barStyle))sk_barStyle
{
    return ^ UISearchBar* (UIBarStyle barStyle) {
        return ({self.barStyle = barStyle;self;});
    };
}

- (UISearchBar* (^)(id<UISearchBarDelegate> delegate))sk_delegate
{
    return ^ UISearchBar* (id<UISearchBarDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UISearchBar* (^)(NSString* text))sk_text
{
    return ^ UISearchBar* (NSString* text) {
        return ({self.text = text;self;});
    };
}

- (UISearchBar* (^)(NSString* prompt))sk_prompt
{
    return ^ UISearchBar* (NSString* prompt) {
        return ({self.prompt = prompt;self;});
    };
}

- (UISearchBar* (^)(NSString* placeholder))sk_placeholder
{
    return ^ UISearchBar* (NSString* placeholder) {
        return ({self.placeholder = placeholder;self;});
    };
}

- (UISearchBar* (^)(BOOL showsBookmarkButton))sk_showsBookmarkButton
{
    return ^ UISearchBar* (BOOL showsBookmarkButton) {
        return ({self.showsBookmarkButton = showsBookmarkButton;self;});
    };
}

- (UISearchBar* (^)(BOOL showsCancelButton))sk_showsCancelButton
{
    return ^ UISearchBar* (BOOL showsCancelButton) {
        return ({self.showsCancelButton = showsCancelButton;self;});
    };
}

- (UISearchBar* (^)(BOOL showsSearchResultsButton))sk_showsSearchResultsButton
{
    return ^ UISearchBar* (BOOL showsSearchResultsButton) {
        return ({self.showsSearchResultsButton = showsSearchResultsButton;self;});
    };
}

- (UISearchBar* (^)(BOOL searchResultsButtonSelected))sk_searchResultsButtonSelected
{
    return ^ UISearchBar* (BOOL searchResultsButtonSelected) {
        return ({self.searchResultsButtonSelected = searchResultsButtonSelected;self;});
    };
}

- (UISearchBar* (^)(UIColor* tintColor))sk_tintColor
{
    return ^ UISearchBar* (UIColor* tintColor) {
        return ({self.tintColor = tintColor;self;});
    };
}

- (UISearchBar* (^)(UIColor* barTintColor))sk_barTintColor
{
    return ^ UISearchBar* (UIColor* barTintColor) {
        return ({self.barTintColor = barTintColor;self;});
    };
}

- (UISearchBar* (^)(UISearchBarStyle searchBarStyle))sk_searchBarStyle
{
    return ^ UISearchBar* (UISearchBarStyle searchBarStyle) {
        return ({self.searchBarStyle = searchBarStyle;self;});
    };
}

- (UISearchBar* (^)(BOOL translucent))sk_translucent
{
    return ^ UISearchBar* (BOOL translucent) {
        return ({self.translucent = translucent;self;});
    };
}

- (UISearchBar* (^)(NSArray<NSString*>* scopeButtonTitles))sk_scopeButtonTitles
{
    return ^ UISearchBar* (NSArray<NSString*>* scopeButtonTitles) {
        return ({self.scopeButtonTitles = scopeButtonTitles;self;});
    };
}

- (UISearchBar* (^)(NSInteger selectedScopeButtonIndex))sk_selectedScopeButtonIndex
{
    return ^ UISearchBar* (NSInteger selectedScopeButtonIndex) {
        return ({self.selectedScopeButtonIndex = selectedScopeButtonIndex;self;});
    };
}

- (UISearchBar* (^)(BOOL showsScopeBar))sk_showsScopeBar
{
    return ^ UISearchBar* (BOOL showsScopeBar) {
        return ({self.showsScopeBar = showsScopeBar;self;});
    };
}

- (UISearchBar* (^)(UIImage* backgroundImage))sk_backgroundImage
{
    return ^ UISearchBar* (UIImage* backgroundImage) {
        return ({self.backgroundImage = backgroundImage;self;});
    };
}

- (UISearchBar* (^)(UIImage* scopeBarBackgroundImage))sk_scopeBarBackgroundImage
{
    return ^ UISearchBar* (UIImage* scopeBarBackgroundImage) {
        return ({self.scopeBarBackgroundImage = scopeBarBackgroundImage;self;});
    };
}

@end
