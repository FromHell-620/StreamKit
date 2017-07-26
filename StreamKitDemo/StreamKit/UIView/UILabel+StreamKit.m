//
//  UILabel+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UILabel+StreamKit.h"

@implementation UILabel (StreamKit)

+ (UILabel* (^)(CGRect frame))sk_init
{
    return ^ UILabel* (CGRect frame) {
        return [[UILabel alloc] initWithFrame:frame];
    };
}

- (UILabel* (^)(NSString* text))sk_text
{
    return ^ UILabel* (NSString* text) {
        return ({self.text = text;self;});
    };
}

- (UILabel* (^)(UIColor* textColor))sk_textColor
{
    return ^ UILabel* (UIColor* textColor) {
        return ({self.textColor = textColor;self;});
    };
}

- (UILabel* (^)(NSInteger fontSize))sk_fontSize
{
    return ^ UILabel* (NSInteger fontSize) {
        return self.sk_font([UIFont systemFontOfSize:fontSize]);
    };
}

- (UILabel* (^)(UIFont* font))sk_font
{
    return ^ UILabel* (UIFont* font) {
        return ({self.font = font;self;});
    };
}

- (UILabel* (^)(NSTextAlignment textAlignment))sk_textAlignment
{
    return ^ UILabel* (NSTextAlignment textAlignment) {
        return ({self.textAlignment = textAlignment;self;});
    };
}

- (UILabel* (^)(NSLineBreakMode lineBreakMode))sk_lineBreakMode
{
    return ^ UILabel* (NSLineBreakMode lineBreakMode) {
        return ({self.lineBreakMode = lineBreakMode;self;});
    };
}

- (UILabel* (^)(UIColor *color))sk_shadowColor {
    return ^ UILabel *(UIColor *color) {
        return ({self.shadowColor = color;self;});
    };
}

- (UILabel* (^)(CGSize size))sk_shadowSize {
    return ^ UILabel *(CGSize size) {
        return ({self.shadowOffset = size;self;});
    };
}

- (UILabel* (^)(NSAttributedString* attributedString))sk_attributedString
{
    return ^ UILabel* (NSAttributedString* attributedString) {
        return ({self.attributedText = attributedString;self;});
    };
}

- (UILabel* (^)(NSInteger numberOfLines))sk_numberOfLines
{
    return ^ UILabel* (NSInteger numberOfLines) {
        return ({self.numberOfLines = numberOfLines;self;});
    };
}

- (UILabel* (^)(UIColor* highlightedTextColor))sk_highlightedTextColor
{
    return ^ UILabel* (UIColor* highlightedTextColor) {
        return ({self.highlightedTextColor = highlightedTextColor;self;});
    };
}

- (UILabel* (^)(BOOL highlighted))sk_highlighted
{
    return ^ UILabel*(BOOL highlighted) {
        return ({self.highlighted = highlighted;self;});
    };
}

- (UILabel* (^)(CGFloat minimumScaleFactor))sk_minimumScaleFactor
{
    return ^ UILabel* (CGFloat minimumScaleFactor) {
        return ({self.minimumScaleFactor = minimumScaleFactor;self;});
    };
}

- (UILabel* (^)(BOOL adjustsFontSizeToFitWidth))sk_adjustsFontSizeToFitWidth
{
    return ^ UILabel* (BOOL adjustsFontSizeToFitWidth) {
        return ({self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;self;});
    };
}

- (UILabel* (^)(UIBaselineAdjustment baselineAdjustment))sk_baselineAdjustment
{
    return ^ UILabel* (UIBaselineAdjustment baselineAdjustment) {
        return ({self.baselineAdjustment = baselineAdjustment;self;});
    };
}

@end
