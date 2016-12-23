//
//  UISearchBar+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UISearchBar+StreamKit.h"
#import "NSObject+StreamKit.h"
#import <objc/runtime.h>
#import <objc/message.h>

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

static NSDictionary* streamMethodAndProtocol = nil;

@implementation UISearchBar (StreamDelegate)

UIKIT_STATIC_INLINE const char* compatibility_type(const char* type) {
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    return type;
#else
    if (strcasecmp(type, "B24@0:8@16") == 0) {
        return "c12@0:4@8";
    }else if(strcasecmp(type, "v24@0:8@16") == 0) {
        return "v12@0:4@8";
    }else if(strcasecmp(type, "v32@0:8@16q24") == 0) {
        return "v16@0:4@8q12";
    }else {
        return NULL;
    }
#endif
}

UIKIT_STATIC_INLINE IMP setupDelegateImplementationWithMethodTypeDesc(const struct objc_method_description method_desc)
{
    IMP imp = NULL;
    SEL Associated_key = sel_registerName([streamMethodAndProtocol[[NSString stringWithUTF8String:sel_getName(method_desc.name)]] UTF8String]);
    if (strcasecmp(method_desc.types, compatibility_type("B24@0:8@16")) == 0) {
        imp = imp_implementationWithBlock(^BOOL(id target,UISearchBar* bar) {
            id<UISearchBarDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:method_desc.name]) {
                return ((BOOL(*)(id,SEL,id))objc_msgSend)(target,method_desc.name,bar);
            }
            
            BOOL(^block)(UISearchBar* searchBar) = objc_getAssociatedObject(target, Associated_key);
            return !block?YES:block(bar);
        });
    }else if (strcasecmp(method_desc.types, compatibility_type("v24@0:8@16")) == 0) {
        imp = imp_implementationWithBlock(^(id target,UISearchBar* bar) {
            id<UISearchBarDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:method_desc.name]) {
                ((void(*)(id,SEL,id))objc_msgSend)(target,method_desc.name,bar);
            }
            
            void(^block)(UISearchBar* searchBar) = objc_getAssociatedObject(target, Associated_key);
            if (block) block(bar);
        });
    }else if (strcasecmp(method_desc.types, compatibility_type("v32@0:8@16@24")) == 0) {
        imp = imp_implementationWithBlock(^(id target,UISearchBar* bar,NSString* text) {
            id<UISearchBarDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:method_desc.name]) {
                ((void(*)(id,SEL,id,id))objc_msgSend)(target,method_desc.name,bar,text);
            }
            
            void(^block)(UISearchBar* searchBar,NSString* text) = objc_getAssociatedObject(target, Associated_key);
            if (block) block(bar,text);
        });
    }else if (strcasecmp(method_desc.types, compatibility_type("v32@0:8@16q24")) == 0) {
        imp = imp_implementationWithBlock(^(id target,UISearchBar* bar,NSInteger selectedScope){
            id<UISearchBarDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:method_desc.name]) {
                ((void(*)(id,SEL,id,NSInteger))objc_msgSend)(target,method_desc.name,bar,selectedScope);
            }
            
            void(^block)(UISearchBar* searchBar,NSInteger selectedScope) = objc_getAssociatedObject(target, Associated_key);
            if (block) block(bar,selectedScope);
        });
    }else {
        imp = imp_implementationWithBlock(^BOOL(id target,UISearchBar* bar,NSRange range,NSString* text) {
            id<UISearchBarDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:method_desc.name]) {
                return ((BOOL(*)(id,SEL,id,NSRange range,NSString* text))objc_msgSend)(target,method_desc.name,bar,range,text);
            }
            
            BOOL(^block)(UISearchBar* searchBar,NSRange range,NSString* text) = objc_getAssociatedObject(target, Associated_key);
            return !block?YES:block(bar,range,text);
        });
    }
    return imp;
}

UIKIT_STATIC_INLINE void initializeDelegateMethod(const char* protocol_method_name)
{
    Class cls = objc_getClass("UISearchBar");
    StreamInitializeDelegateMethod(cls, "UISearchBarDelegate", protocol_method_name, setupDelegateImplementationWithMethodTypeDesc);
}

+(void)load
{
    streamMethodAndProtocol = @{
                                @"searchBarShouldBeginEditing:":@"sk_searchBarShouldBeginEditing",
                                @"searchBarTextDidBeginEditing:":@"sk_searchBarTextDidBeginEditing",
                                @"searchBarShouldEndEditing:":@"sk_searchBarShouldEndEditing",
                                @"searchBarTextDidEndEditing:":@"sk_searchBarTextDidEndEditing",
                                @"searchBar:textDidChange:":@"sk_searchBarTextDidChange",
                                @"searchBar:shouldChangeTextInRange:replacementText:":@"sk_searchBarShouldChangeTextInRange",
                                @"searchBarSearchButtonClicked:":@"sk_searchBarSearchButtonClicked",
                                @"searchBarBookmarkButtonClicked:":@"sk_searchBarBookmarkButtonClicked",
                                @"searchBarCancelButtonClicked:":@"sk_searchBarCancelButtonClicked",
                                @"searchBarResultsListButtonClicked:":@"sk_searchBarResultsListButtonClicked",
                                @"searchBar:selectedScopeButtonIndexDidChange:":@"sk_searchBarSelectedScopeButtonIndexDidChange"
                                };
    
    [streamMethodAndProtocol enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        StreamSetImplementationToMethod(objc_getClass("UISearchBar"), obj.UTF8String, key.UTF8String, initializeDelegateMethod);
    }];
}

- (UISearchBar* (^)(BOOL(^block)(UISearchBar* searchBar)))sk_searchBarShouldBeginEditing
{
    return ^ UISearchBar* (BOOL(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarTextDidBeginEditing
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(BOOL(^block)(UISearchBar* searchBar)))sk_searchBarShouldEndEditing
{
    return ^ UISearchBar* (BOOL(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarTextDidEndEditing
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar,NSString* searchText)))sk_searchBarTextDidChange
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar,NSString* searchText)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(BOOL(^block)(UISearchBar* searchBar,NSRange range,NSString* text)))sk_searchBarShouldChangeTextInRange
{
    return ^ UISearchBar* (BOOL(^block)(UISearchBar* searchBar,NSRange range,NSString* text)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarSearchButtonClicked
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarBookmarkButtonClicked
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarCancelButtonClicked
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar)))sk_searchBarResultsListButtonClicked
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UISearchBar* (^)(void(^block)(UISearchBar* searchBar,NSInteger selectedScope)))sk_searchBarSelectedScopeButtonIndexDidChange
{
    return ^ UISearchBar* (void(^block)(UISearchBar* searchBar,NSInteger selectedScope)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

@end
