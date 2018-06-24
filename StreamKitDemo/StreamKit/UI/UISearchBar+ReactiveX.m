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

@implementation UISearchBar (ReactiveX)

//- (SKSignal*)sk_signalForTextChange
//{
//    @weakify(self)
//    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
//        @strongify(self)
//        self.sk_searchBarTextDidChange(^(UISearchBar* searchBar,NSString* searchText) {
//            [subscriber sendNext:searchText];
//        });
//    }];
//}
//
//- (SKSignal*)sk_signalForBeginEdite
//{
//    @weakify(self)
//    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
//        @strongify(self)
//        self.sk_searchBarTextDidBeginEditing(^(UISearchBar* searchBar) {
//            [subscriber sendNext:searchBar];
//            self.isEditing = YES;
//        });
//    }];
//}
//
//- (SKSignal*)sk_signalForEndEdite
//{
//    @weakify(self)
//    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
//        @strongify(self)
//        self.sk_searchBarTextDidEndEditing(^(UISearchBar* searchBar) {
//            [subscriber sendNext:searchBar];
//            self.isEditing = NO;
//        });
//    }];
//}
//
//- (SKSignal*)sk_signalForClickSearchButton
//{
//    @weakify(self)
//    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
//        @strongify(self)
//        self.sk_searchBarSearchButtonClicked(^(UISearchBar* searchBar) {
//            [subscriber sendNext:searchBar];
//        });
//    }];
//}
//
//- (SKSignal*)sk_signalForClickCancelButton {
//    @weakify(self)
//    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
//        @strongify(self)
//        self.sk_searchBarCancelButtonClicked(^(UISearchBar* searchBar) {
//            [subscriber sendNext:searchBar];
//        });
//    }];
//}

@end
