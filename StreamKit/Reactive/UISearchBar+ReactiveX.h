//
//  UISearchBar+ReactiveX.h
//  StreamKitDemo
//
//  Created by imac on 2017/4/17.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSignal;

@interface UISearchBar (ReactiveX)

- (SKSignal*)sk_signalForEndEdite;

- (SKSignal*)sk_signalForBeginEdite;

- (SKSignal*)sk_signalForTextChange;

- (SKSignal*)sk_signalForClickSearchButton;

@end
