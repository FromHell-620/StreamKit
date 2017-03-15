//
//  UISwitch+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UISwitch+StreamKit.h"

@implementation UISwitch (StreamKit)

+ (UISwitch* (^)(CGRect frame))sk_init
{
    return ^ UISwitch* (CGRect frame) {
        return [[UISwitch alloc] initWithFrame:frame];
    };
}

- (UISwitch* (^)(UIColor* onTintColor))sk_onTintColor
{
    return ^ UISwitch* (UIColor* onTintColor) {
        return ({self.onTintColor = onTintColor;self;});
    };
}

- (UISwitch* (^)(UIColor* tintColor))sk_tintColor
{
    return ^ UISwitch* (UIColor* tintColor) {
        return ({self.tintColor = tintColor;self;});
    };
}

- (UISwitch* (^)(UIColor* thumbTintColor))sk_thumbTintColor
{
    return ^ UISwitch* (UIColor* thumbTintColor) {
        return ({self.thumbTintColor = thumbTintColor;self;});
    };
}

- (UISwitch* (^)(UIImage* onImage))sk_onImage
{
    return ^ UISwitch* (UIImage* onImage) {
        return ({self.onImage = onImage;self;});
    };
}

- (UISwitch* (^)(UIImage* offImage))sk_offImage
{
    return ^ UISwitch* (UIImage* offImage) {
        return ({self.offImage = offImage;self;});
    };
}

- (UISwitch* (^)(BOOL on))sk_on
{
    return ^ UISwitch* (BOOL on) {
        return ({self.on = on;self;});
    };
}

- (UISwitch* (^)(BOOL on,BOOL animaled))sk_setOnWithAnimaled
{
    return ^ UISwitch* (BOOL on,BOOL animaled) {
        return ({[self setOn:on animated:animaled];self;});
    };
}

@end
