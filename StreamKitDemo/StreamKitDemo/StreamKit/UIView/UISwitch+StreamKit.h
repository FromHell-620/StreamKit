//
//  UISwitch+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (StreamKit)

+ (UISwitch* (^)(CGRect frame))sk_init;

- (UISwitch* (^)(UIColor* onTintColor))sk_onTintColor;

- (UISwitch* (^)(UIColor* tintColor))sk_tintColor;

- (UISwitch* (^)(UIColor* thumbTintColor))sk_thumbTintColor;

- (UISwitch* (^)(UIImage* onImage))sk_onImage;

- (UISwitch* (^)(UIImage* offImage))sk_offImage;

- (UISwitch* (^)(BOOL on))sk_on;

- (UISwitch* (^)(BOOL on,BOOL animaled))sk_setOnWithAnimaled;

@end
