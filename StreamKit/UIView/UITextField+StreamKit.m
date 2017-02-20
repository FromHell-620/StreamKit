//
//  UITextField+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UITextField+StreamKit.h"
#import "NSObject+StreamKit.h"
@import ObjectiveC.runtime;
@import ObjectiveC.message;

@implementation UITextField (StreamKit)

+ (UITextField* (^)(CGRect frame))sk_init
{
    return ^ UITextField* (CGRect frame) {
        return [[UITextField alloc] initWithFrame:frame];
    };
}

- (UITextField* (^)(NSString* text))sk_text
{
    return ^ UITextField* (NSString* text) {
        return ({self.text = text;self;});
    };
}

- (UITextField* (^)(NSAttributedString* attributedText))sk_attributedText
{
    return ^ UITextField* (NSAttributedString* attributedText) {
        return ({self.attributedText = attributedText;self;});
    };
}

- (UITextField* (^)(UIColor* textColor))sk_textColor
{
    return ^ UITextField* (UIColor* textColor) {
        return ({self.textColor = textColor;self;});
    };
}

- (UITextField* (^)(NSInteger fontSize))sk_fontSize
{
    return ^ UITextField* (NSInteger fontSize) {
        return ({self.font = [UIFont systemFontOfSize:fontSize];self;});
    };
}

- (UITextField* (^)(UIFont* font))sk_font
{
    return ^ UITextField* (UIFont* font) {
        return ({self.font = font;self;});
    };
}

- (UITextField* (^)(NSTextAlignment textAlignment))sk_textAlignment
{
    return ^ UITextField* (NSTextAlignment textAlignment) {
        return ({self.textAlignment = textAlignment;self;});
    };
}

- (UITextField* (^)(UITextBorderStyle borderStyle))sk_borderStyle
{
    return ^ UITextField* (UITextBorderStyle borderStyle) {
        return ({self.borderStyle = borderStyle;self;});
    };
}

- (UITextField* (^)(NSDictionary<NSString*,id>* defaultTextAttributes))sk_defaultTextAttributes
{
    return ^ UITextField* (NSDictionary<NSString*,id>* defaultTextAttributes) {
        return ({self.defaultTextAttributes = defaultTextAttributes;self;});
    };
}

- (UITextField* (^)(NSString* placeholder))sk_placeholder
{
    return ^ UITextField* (NSString* placeholder) {
        return ({self.placeholder = placeholder;self;});
    };
}

- (UITextField* (^)(NSAttributedString* attributedPlaceholder))sk_attributedPlaceholder
{
    return ^ UITextField* (NSAttributedString* attributedPlaceholder) {
        return ({self.attributedPlaceholder = attributedPlaceholder;self;});
    };
}

- (UITextField* (^)(BOOL clearsOnBeginEditing))sk_clearsOnBeginEditing
{
    return ^ UITextField* (BOOL clearsOnBeginEditing) {
        return ({self.clearsOnBeginEditing = clearsOnBeginEditing;self;});
    };
}

- (UITextField* (^)(BOOL adjustsFontSizeToFitWidth))sk_adjustsFontSizeToFitWidth
{
    return ^ UITextField* (BOOL adjustsFontSizeToFitWidth) {
        return ({self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;self;});
    };
}

- (UITextField* (^)(CGFloat minimumFontSize))sk_minimumFontSize
{
    return ^ UITextField* (CGFloat minimumFontSize) {
        return ({self.minimumFontSize = minimumFontSize;self;});
    };
}

- (UITextField* (^)(id<UITextFieldDelegate> delegate))sk_delegate
{
    return ^ UITextField* (id<UITextFieldDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UITextField* (^)(UIImage* background))sk_background
{
    return ^ UITextField* (UIImage* background) {
        return ({self.background = background;self;});
    };
}

- (UITextField* (^)(UIImage* disabledBackground))sk_disabledBackground
{
    return ^ UITextField* (UIImage* disabledBackground) {
        return ({self.disabledBackground = disabledBackground;self;});
    };
}

- (UITextField* (^)(BOOL allowsEditingTextAttributes))sk_allowsEditingTextAttributes
{
    return ^ UITextField* (BOOL allowsEditingTextAttributes) {
        return ({self.allowsEditingTextAttributes = allowsEditingTextAttributes;self;});
    };
}

- (UITextField* (^)(NSDictionary<NSString*,id>* typingAttributes))sk_typingAttributes
{
    return ^ UITextField* (NSDictionary<NSString*,id>* typingAttributes) {
        return ({self.typingAttributes = typingAttributes;self;});
    };
}

- (UITextField* (^)(UITextFieldViewMode clearButtonMode))sk_clearButtonMode
{
    return ^ UITextField* (UITextFieldViewMode clearButtonMode) {
        return ({self.clearButtonMode = clearButtonMode;self;});
    };
}

- (UITextField* (^)(UIView* leftView))sk_leftView
{
    return ^ UITextField* (UIView* leftView) {
        return ({self.leftView = leftView;self;});
    };
}

- (UITextField* (^)(UITextFieldViewMode leftViewMode))sk_leftViewMode
{
    return ^ UITextField* (UITextFieldViewMode leftViewMode) {
        return ({self.leftViewMode = leftViewMode;self;});
    };
}

- (UITextField* (^)(UIView* rightView))sk_rightView
{
    return ^ UITextField* (UIView* rightView) {
        return ({self.rightView = rightView;self;});
    };
}

- (UITextField* (^)(UITextFieldViewMode rightViewMode))sk_rightViewMode
{
    return ^ UITextField* (UITextFieldViewMode rightViewMode) {
        return ({self.rightViewMode = rightViewMode;self;});
    };
}

@end

@implementation UITextField (StreamDelegate)

UIKIT_STATIC_INLINE NSDictionary* StreamMethodAndProtocol()
{
    static NSDictionary* streamMethodAndProtocol = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamMethodAndProtocol = @{@"textFieldShouldBeginEditing:":@"sk_textFieldShouldBeginEditing",
                                    @"textFieldDidBeginEditing:":@"sk_textFieldDidBeginEditing",
                                    @"textFieldShouldEndEditing:":@"sk_textFieldShouldEndEditing",
                                    @"textFieldDidEndEditing:":@"sk_textFieldDidEndEditing",
                                    @"textFieldDidEndEditing:reason:":@"sk_textFieldDidEndEditingWithReaseon",
                                @"textField:shouldChangeCharactersInRange:replacementString:":@"sk_textFieldShouldChangeCharactersInRange",
                                    @"textFieldShouldClear:":@"sk_textFieldShouldClear",
                                    @"textFieldShouldReturn:":@"sk_textFieldShouldReturn"
                                    };
    });
    return streamMethodAndProtocol;
}

+ (void)load
{
    [StreamMethodAndProtocol() enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        StreamSetImplementationToDelegateMethod(objc_getClass("UITextField"), @protocol(UITextFieldDelegate), obj.UTF8String, key.UTF8String);
    }];
}

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldBeginEditing
{
    return ^ UITextField* (BOOL(^block)(UITextField* textField)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(void(^block)(UITextField* textField)))sk_textFieldDidBeginEditing
{
    return ^ UITextField* (void(^block)(UITextField* textField)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldEndEditing
{
    return ^ UITextField* (BOOL(^block)(UITextField* textField)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(void(^block)(UITextField* textField)))sk_textFieldDidEndEditing
{
    return ^ UITextField* (void(^block)(UITextField* textField)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(void(^block)(UITextField* textField,UITextFieldDidEndEditingReason reason)))sk_textFieldDidEndEditingWithReaseon
{
    return ^ UITextField* (void(^block)(UITextField* textField,UITextFieldDidEndEditingReason reason)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(BOOL(^block)(UITextField* textField,NSRange range,NSString* string)))sk_textFieldShouldChangeCharactersInRange
{
    return ^ UITextField* (BOOL(^block)(UITextField* textField,NSRange range,NSString* string)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldClear
{
    return ^ UITextField* (BOOL(^block)(UITextField* textField)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldReturn
{
    return ^ UITextField* (BOOL(^block)(UITextField* textField)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

@end
