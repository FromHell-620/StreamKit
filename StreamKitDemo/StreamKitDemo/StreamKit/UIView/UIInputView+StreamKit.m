//
//  UIInputView+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIInputView+StreamKit.h"

@implementation UIInputView (StreamKit)

+ (UIInputView* (^)(CGRect frame,UIInputViewStyle inputViewStyle))sk_init
{
    return ^ UIInputView* (CGRect frame,UIInputViewStyle inputViewStyle) {
        return ({[[self alloc] initWithFrame:frame inputViewStyle:inputViewStyle];});
    };
}

- (UIInputView* (^)(BOOL allowsSelfSizing))sk_allowsSelfSizing
{
    return ^ UIInputView* (BOOL allowsSelfSizing) {
        return ({self.allowsSelfSizing = allowsSelfSizing;self;});
    };
}

@end
