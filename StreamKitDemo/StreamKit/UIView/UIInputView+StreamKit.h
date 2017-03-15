//
//  UIInputView+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInputView (StreamKit)

/**
 Creates a new inputView.
 @code
 UIInputView* input = UIInputView.sk_init(frame,inputViewStyle);
 @endcode
 @return a block which receive a frame and a inputViewStyle.
 */
+ (UIInputView* (^)(CGRect frame,UIInputViewStyle inputViewStyle))sk_init;

/**
 Set allowsSelfSizing.
 @code
 self.sk_allowsSelfSizing(allowsSelfSizing);
 @endcode
 */
- (UIInputView* (^)(BOOL allowsSelfSizing))sk_allowsSelfSizing;

@end
