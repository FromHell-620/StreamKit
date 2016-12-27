//
//  UIInputView+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInputView (StreamKit)

+ (UIInputView* (^)(CGRect frame,UIInputViewStyle inputViewStyle))sk_init;

- (UIInputView* (^)(BOOL allowsSelfSizing))sk_allowsSelfSizing;

@end
