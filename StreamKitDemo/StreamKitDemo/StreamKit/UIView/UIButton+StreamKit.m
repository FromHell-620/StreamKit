//
//  UIButton+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIButton+StreamKit.h"

@implementation UIButton (StreamKit)

+ (UIButton* (^)(CGRect frame))sk_initWithFrame
{
    return ^ UIButton* (CGRect frame) {
        return ({UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];button.frame = frame;button;});
    };
}

+ (UIButton* (^)(UIButtonType buttonType))sk_initWithType
{
    return ^ UIButton* (UIButtonType buttonType) {
        return [UIButton buttonWithType:buttonType];
    };
}

- (UIButton* (^)(UIFont* font))sk_setFont
{
    return ^ UIButton* (UIFont* font) {
        return ({self.titleLabel.font = font;self;});
    };
}

- (UIButton* (^)(NSInteger fontSize))sk_setFontSize
{
    return ^ UIButton* (NSInteger fontSize) {
        return self.sk_setFont([UIFont systemFontOfSize:fontSize]);
    };
}

- (UIButton* (^)(UIEdgeInsets titleEdgeInsets))sk_titleEdgeInsets
{
    return ^ UIButton* (UIEdgeInsets titleEdgeInsets) {
        return ({self.titleEdgeInsets = titleEdgeInsets;self;});
    };
}

- (UIButton* (^)(UIEdgeInsets imageEdgeInsets))sk_imageEdgeInsets
{
    return ^ UIButton* (UIEdgeInsets imageEdgeInsets) {
        return ({self.imageEdgeInsets = imageEdgeInsets;self;});
    };
}

- (UIButton* (^)(NSString* title))sk_setTitleNormal
{
    return ^ UIButton* (NSString* title) {
        return self.sk_setTitle(title,UIControlStateNormal);
    };
}

- (UIButton* (^)(NSString* title))sk_setTitleHighlight
{
    return ^ UIButton* (NSString* title) {
        return self.sk_setTitle(title,UIControlStateHighlighted);
    };
}

- (UIButton* (^)(NSString* title))sk_setTitleSelect
{
    return ^ UIButton* (NSString* title) {
        return self.sk_setTitle(title,UIControlStateSelected);
    };
}

- (UIButton* (^)(NSString* title,UIControlState state))sk_setTitle
{
    return ^ UIButton* (NSString* title,UIControlState state) {
        return ({[self setTitle:title forState:state];self;});
    };
}

- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorNormal
{
    return ^ UIButton* (UIColor* titleColor) {
        return self.sk_setTitleColor(titleColor,UIControlStateNormal);
    };
}

- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorHightlight
{
    return ^ UIButton* (UIColor* titleColor) {
        return self.sk_setTitleColor(titleColor,UIControlStateHighlighted);
    };
}

- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorSelect
{
    return ^ UIButton* (UIColor* titleColor) {
        return self.sk_setTitleColor(titleColor,UIControlStateSelected);
    };
}

- (UIButton* (^)(UIColor* titleColor,UIControlState state))sk_setTitleColor
{
    return ^ UIButton* (UIColor* titleColor,UIControlState state) {
        return ({[self setTitleColor:titleColor forState:state];self;});
    };
}

- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringNormal
{
    return ^ UIButton* (NSAttributedString* attributedString) {
        return self.sk_setAttributedString(attributedString,UIControlStateNormal);
    };
}

- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringHightlight
{
    return ^ UIButton* (NSAttributedString* attributedString) {
        return self.sk_setAttributedString(attributedString,UIControlStateHighlighted);
    };
}

- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringSelect
{
    return ^ UIButton* (NSAttributedString* attributedString) {
        return self.sk_setAttributedString(attributedString,UIControlStateSelected);
    };
}

- (UIButton* (^)(NSAttributedString* attributedString,UIControlState state))sk_setAttributedString
{
    return ^ UIButton* (NSAttributedString* attributedString,UIControlState state) {
        
        return ({[self setAttributedTitle:attributedString forState:state];self;});
    };
}

- (UIButton* (^)(UIImage* image))sk_setImageNormal
{
    return ^ UIButton* (UIImage* image) {
        return self.sk_setImage(image,UIControlStateNormal);
    };
}

- (UIButton* (^)(UIImage* image))sk_setImageHightlight
{
    return ^ UIButton* (UIImage* image) {
        return self.sk_setImage(image,UIControlStateHighlighted);
    };
}

- (UIButton* (^)(UIImage* image))sk_setImageSelect
{
    return ^ UIButton* (UIImage* image) {
        return self.sk_setImage(image,UIControlStateSelected);
    };
}

- (UIButton* (^)(UIImage* image,UIControlState state))sk_setImage
{
    return ^ UIButton* (UIImage* image,UIControlState state) {
        return ({[self setImage:image forState:state];self;});
    };
}

- (UIButton* (^)(UIImage* image))sk_setBackgroundImageNormal
{
    return ^ UIButton* (UIImage* image) {
        return self.sk_setBackgroundImage(image,UIControlStateNormal);
    };
}

- (UIButton* (^)(UIImage* image))sk_setBackgroundImageHightlight
{
    return ^ UIButton* (UIImage* image) {
        return self.sk_setBackgroundImage(image,UIControlStateHighlighted);
    };
}

- (UIButton* (^)(UIImage* image))sk_setBackgroundImageSelect
{
    return ^ UIButton* (UIImage* image) {
        return self.sk_setBackgroundImage(image,UIControlStateSelected);
    };
}

- (UIButton* (^)(UIImage* image,UIControlState state))sk_setBackgroundImage
{
    return ^ UIButton* (UIImage* image,UIControlState state) {
        return ({[self setBackgroundImage:image forState:state];self;});
    };
}

@end
