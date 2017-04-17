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

@implementation UISearchBar (ReactiveX)

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
        self.sk_searchBarShouldBeginEditing(^BOOL(UISearchBar* searchBar) {
            NSNumber* value = [subscriber sendNextWithReturnValue:searchBar];
            return value?value.boolValue:YES;
        });
    }];
}

- (SKSignal*)sk_signalForEndEdite
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       @strongify(self)
        self.sk_searchBarShouldBeginEditing(^BOOL(UISearchBar* searchBar) {
            NSNumber* number = [subscriber sendNextWithReturnValue:searchBar];
            return number?number.boolValue:YES;
        });
    }];
}

@end
