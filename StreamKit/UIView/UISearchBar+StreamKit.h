//
//  UISearchBar+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
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

/**
 Creates a new searchBar by the given frame.
 @code
 UISearchBar* searchBar = UISearchBar.sk_init(frame);
 @endcode
 */
+ (UISearchBar* (^)(CGRect frame))sk_init;

/**
 Set barStyle.
 @code
 self.sk_barStyle(barStyle);
 @endcode
 */
- (UISearchBar* (^)(UIBarStyle barStyle))sk_barStyle;

/**
 Set delegate.
 @code
 self.sk_delegate(delegate);
 @endcode
 */
- (UISearchBar* (^)(id<UISearchBarDelegate> delegate))sk_delegate;

/**
 Set text.
 @code
 self.sk_text(text);
 @endcode
 */
- (UISearchBar* (^)(NSString* text))sk_text;

/**
 Set prompt.
 @code
 self.sk_prompt(prompt);
 @endcode
 */
- (UISearchBar* (^)(NSString* prompt))sk_prompt;

/**
 Set placeholder.
 @code
 self.sk_placeholder(placeholder);
 @endcode
 */
- (UISearchBar* (^)(NSString* placeholder))sk_placeholder;

/**
 Set showsBookmarkButton.
 @code
 self.sk_showsBookmarkButton(showsBookmarkButton);
 @endcode
 */
- (UISearchBar* (^)(BOOL showsBookmarkButton))sk_showsBookmarkButton;

/**
 Set showsCancelButton.
 @code
 self.sk_showsCancelButton(showsCancelButton);
 @endcode
 */
- (UISearchBar* (^)(BOOL showsCancelButton))sk_showsCancelButton;

/**
 Set showsSearchResultsButton.
 @code
 self.sk_showsSearchResultsButton(showsSearchResultsButton);
 @endcode
 */
- (UISearchBar* (^)(BOOL showsSearchResultsButton))sk_showsSearchResultsButton;

/**
 Set searchResultsButtonSelected.
 @code
 self.sk_searchResultsButtonSelected(searchResultsButtonSelected);
 @endcode
 */
- (UISearchBar* (^)(BOOL searchResultsButtonSelected))sk_searchResultsButtonSelected;

/**
 Set tintColor.
 @code
 self.sk_tintColor(tintColor);
 @endcode
 */
- (UISearchBar* (^)(UIColor* tintColor))sk_tintColor;

/**
 Set barTintColor.
 @code
 self.sk_barTintColor(barTintColor);
 @endcode
 */
- (UISearchBar* (^)(UIColor* barTintColor))sk_barTintColor;

/**
 Set searchBarStyle.
 @code
 self,sk_searchBarStyle(searchBarStyle);
 @endcode
 */
- (UISearchBar* (^)(UISearchBarStyle searchBarStyle))sk_searchBarStyle;

/**
 Set translucent.
 @code
 self.sk_translucent(translucent);
 @endcode
 */
- (UISearchBar* (^)(BOOL translucent))sk_translucent;

/**
 Set scopeButtonTitles.
 @code
 self.sk_scopeButtonTitles(scopeButtonTitles);
 @endcode
 */
- (UISearchBar* (^)(NSArray<NSString*>* scopeButtonTitles))sk_scopeButtonTitles;

/**
 Set selectedScopeButtonIndex.
 @code
 self.sk_selectedScopeButtonIndex(selectedScopeButtonIndex);
 @endcode
 */
- (UISearchBar* (^)(NSInteger selectedScopeButtonIndex))sk_selectedScopeButtonIndex;

/**
 Set showsScopeBar.
 @code
 self.sk_showsScopeBar(showsScopeBar);
 @endcode
 */
- (UISearchBar* (^)(BOOL showsScopeBar))sk_showsScopeBar;

/**
 Set backgroundImage.
 @code
 self.sk_backgroundImage(backgroundImage);
 @endcode
 */
- (UISearchBar* (^)(UIImage* backgroundImage))sk_backgroundImage;

/**
 Set scopeBarBackgroundImage.
 @code
 self.sk_scopeBarBackgroundImage(scopeBarBackgroundImage);
 @endcode
 */
- (UISearchBar* (^)(UIImage* scopeBarBackgroundImage))sk_scopeBarBackgroundImage;

@end

@interface UISearchBar (StreamDelegate)

/**
 Instead of the 'searchBarShouldBeginEditing:'.
 @code
 self.sk_searchBarShouldBeginEditing(^BOOL(UISearchBar* searchBar){
    your code;
 });
 @endcode
 @return a block which receive a event block and you should invoke.
         the event block will invoke when the delegate methods execute.
 */
- (UISearchBar* (^)(BOOL(^block)(UISearchBar* searchBar)))sk_searchBarShouldBeginEditing;

/**
 Instead of the 'searchBarTextDidBeginEditing:'
 @code
 self.sk_searchBarTextDidBeginEditing(^(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarTextDidBeginEditing;

/**
 Intead of the 'searchBarShouldEndEditing:'.
 @code
 self.sk_searchBarShouldEndEditing(^BOOL(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(BOOL(^block)(UISearchBar* searchBar)))sk_searchBarShouldEndEditing;

/**
 Instead of the 'searchBarTextDidEndEditing:'.
 @code
 self.sk_searchBarTextDidEndEditing(^(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarTextDidEndEditing;

/**
 Instead of the 'searchBar:textDidChange:'.
 @code
 self.sk_searchBarTextDidChange(^(UISearchBar* searchBar,NSString* searchText){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar,NSString* searchText)))sk_searchBarTextDidChange;

/**
 Instead of the 'searchBar:shouldChangeTextInRange:replacementText:'.
 @code
 self.sk_searchBarShouldChangeTextInRange(^BOOL(UISearchBar* searchBar,NSRange range,NSString* text){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(BOOL(^block)(UISearchBar* searchBar,NSRange range,NSString* text)))sk_searchBarShouldChangeTextInRange;

/**
 Instead of the 'searchBarSearchButtonClicked:'.
 @code
 self.sk_searchBarSearchButtonClicked(^(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarSearchButtonClicked;

/**
 Instead of the 'searchBarBookmarkButtonClicked:'.
 @code
 self.sk_searchBarBookmarkButtonClicked(^(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarBookmarkButtonClicked;

/**
 instead of the 'searchBarCancelButtonClicked:'.
 @code
 self.sk_searchBarCancelButtonClicked(^(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarCancelButtonClicked;

/**
 Instead of the 'searchBarResultsListButtonClicked:'.
 @code
 self.sk_searchBarResultsListButtonClicked(^(UISearchBar* searchBar){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarResultsListButtonClicked;

/**
 Instead of the 'searchBar:selectedScopeButtonIndexDidChange:'.
 @code
 self.sk_searchBarSelectedScopeButtonIndexDidChange(^(UISearchBar* searchBar,NSInteger selectedScope){
    your code;
 });
 @endcode
 */
- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar,NSInteger selectedScope)))sk_searchBarSelectedScopeButtonIndexDidChange;

@end
