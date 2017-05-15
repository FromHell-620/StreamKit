//
//  UISearchBar+ReactiveX.m
//  StreamKitDemo
//
//  Created by imac on 2017/4/17.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UISearchBar+ReactiveX.h"
#import "UISearchBar+StreamKit.h"
#import "SKSignal.h"
#import "SKSubscriber.h"
#import "SKObjectifyMarco.h"
#import "SKKeyPathMarco.h"

@import ObjectiveC.runtime;

@interface UISearchBar ()

@property (nonatomic,assign,readwrite) BOOL isEditing;

@end

@implementation UISearchBar (ReactiveX)

- (void)setIsEditing:(BOOL)isEditing {
    [self willChangeValueForKey:@sk_keypath(self,isEditing)];
    objc_setAssociatedObject(self, _cmd, @(isEditing), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@sk_keypath(self,isEditing)];
}

- (BOOL)isEditing {
    return SK_ClassForceify(objc_getAssociatedObject(self, @selector(setIsEditing:)), NSNumber).boolValue;
}

- (SKSignal*)sk_signalForClickSearchButton
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_searchBarSearchButtonClicked(^(UISearchBar* searchBar) {
            [subscriber sendNext:searchBar];
        });
    }];
}

- (SKSignal*)sk_signalForTextChange
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_searchBarTextDidChange(^(UISearchBar* searchBar,NSString* searchText) {
            [subscriber sendNext:searchText];
        });
    }];
}

- (SKSignal*)sk_signalForBeginEdite
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_searchBarTextDidBeginEditing(^(UISearchBar* searchBar) {
            [subscriber sendNext:searchBar];
            self.isEditing = YES;
        });
    }];
}

- (SKSignal*)sk_signalForEndEdite
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_searchBarTextDidEndEditing(^(UISearchBar* searchBar) {
            [subscriber sendNext:searchBar];
            self.isEditing = NO;
        });
    }];
}

@end
