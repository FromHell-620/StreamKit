//
//  UITextView+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/23.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UITextView+StreamKit.h"
#import "NSObject+StreamKit.h"

@implementation UITextView (StreamKit)

+ (UITextView* (^)(CGRect frame))sk_initWithFrame
{
    return ^ UITextView* (CGRect frame) {
        return [[UITextView alloc] initWithFrame:frame];
    };
}

+ (UITextView* (^)(CGRect frame,NSTextContainer* container))sk_initWithFrameAndContainer
{
    return ^ UITextView* (CGRect frame,NSTextContainer* container) {
        return [[UITextView alloc] initWithFrame:frame textContainer:container];
    };
}

- (UITextView* (^)(id<UITextViewDelegate> delegate))sk_delegate
{
    return ^ UITextView* (id<UITextViewDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UITextView* (^)(NSString* text))sk_text
{
    return ^ UITextView* (NSString* text) {
        return ({self.text = text;self;});
    };
}

- (UITextView* (^)(UIFont* font))sk_font
{
    return ^ UITextView* (UIFont* font) {
        return ({self.font = font;self;});
    };
}

- (UITextView* (^)(NSInteger fontSize))sk_fontSize
{
    return ^ UITextView* (NSInteger fontSize) {
        return ({self.font = [UIFont systemFontOfSize:fontSize];self;});
    };
}

- (UITextView* (^)(UIColor* textColor))sk_textColor
{
    return ^ UITextView* (UIColor* textColor) {
        return ({self.textColor = textColor;self;});
    };
}

- (UITextView* (^)(NSTextAlignment textAlignment))sk_textAlignment
{
    return ^ UITextView* (NSTextAlignment textAlignment) {
        return ({self.textAlignment = textAlignment;self;});
    };
}

- (UITextView* (^)(NSRange selectedRange))sk_selectedRange
{
    return ^ UITextView* (NSRange selectedRange) {
        return ({self.selectedRange = selectedRange;self;});
    };
}

- (UITextView* (^)(BOOL editable))sk_editable
{
    return ^ UITextView* (BOOL editable) {
        return ({self.editable = editable;self;});
    };
}

- (UITextView* (^)(BOOL selectable))sk_selectable
{
    return ^ UITextView* (BOOL selectable) {
        return ({self.selectable = selectable;self;});
    };
}

- (UITextView* (^)(UIDataDetectorTypes dataDetectorTypes))sk_dataDetectorTypes
{
    return ^ UITextView* (UIDataDetectorTypes dataDetectorTypes) {
        return ({self.dataDetectorTypes = dataDetectorTypes;self;});
    };
}

- (UITextView* (^)(BOOL allowsEditingTextAttributes))sk_allowsEditingTextAttributes
{
    return ^ UITextView* (BOOL allowsEditingTextAttributes) {
        return ({self.allowsEditingTextAttributes = allowsEditingTextAttributes;self;});
    };
}

- (UITextView* (^)(NSAttributedString* attributedText))sk_attributedText
{
    return ^ UITextView* (NSAttributedString* attributedText) {
        return ({self.attributedText = attributedText;self;});
    };
}

- (UITextView* (^)(NSDictionary<NSString*,id>* typingAttributes))sk_typingAttributes
{
    return ^ UITextView* (NSDictionary<NSString*,id>* typingAttributes) {
        return ({self.typingAttributes = typingAttributes;self;});
    };
}

- (UITextView* (^)(UIView* inputView))sk_inputView
{
    return ^ UITextView* (UIView* inputView) {
        return ({self.inputView = inputView;self;});
    };
}

- (UITextView* (^)(UIView* inputAccessoryView))sk_inputAccessoryView
{
    return ^ UITextView* (UIView* inputAccessoryView) {
        return ({self.inputAccessoryView = inputAccessoryView;self;});
    };
}

- (UITextView* (^)(BOOL clearsOnInsertion))sk_clearsOnInsertion
{
    return ^ UITextView* (BOOL clearsOnInsertion) {
        return ({self.clearsOnInsertion = clearsOnInsertion;self;});
    };
}

- (UITextView* (^)(UIEdgeInsets textContainerInset))sk_textContainerInset
{
    return ^ UITextView* (UIEdgeInsets textContainerInset) {
        return ({self.textContainerInset = textContainerInset;self;});
    };
}

- (UITextView* (^)(NSDictionary<NSString*,id>* linkTextAttributes))sk_linkTextAttributes
{
    return ^ UITextView* (NSDictionary<NSString*,id>* linkTextAttributes) {
        return ({self.linkTextAttributes = linkTextAttributes;self;});
    };
}

@end

@implementation UITextView (StreamDelegate)

+ (void)load
{
    NSDictionary* streamMethodsAndProtocol = @{
                                               @"textViewShouldBeginEditing:":@"sk_textViewShouldBeginEditing",
                                               @"textViewShouldEndEditing:":@"sk_textViewShouldEndEditing",
                                               @"textViewDidBeginEditing:":@"sk_textViewDidBeginEditing",
                                               @"textViewDidEndEditing:":@"sk_textViewDidEndEditing",
                                               @"textView:shouldChangeTextInRange:replacementText:":@"sk_textViewShouldChangeTextInRange",
                                               @"textViewDidChange:":@"sk_textViewDidChange",
                                               @"textViewDidChangeSelection:":@"sk_textViewDidChangeSelection"
                                               };
    [streamMethodsAndProtocol enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        StreamSetImplementationToDelegateMethod(self, @protocol(UITextViewDelegate), obj.UTF8String, key.UTF8String);
    }];
}

- (UITextView* (^)(BOOL(^block)(UITextView* textView)))sk_textViewShouldBeginEditing
{
    return ^ UITextView* (BOOL(^block)(UITextView* textView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextView* (^)(BOOL(^block)(UITextView* textView)))sk_textViewShouldEndEditing
{
    return ^ UITextView* (BOOL(^block)(UITextView* textView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidBeginEditing
{
    return ^ UITextView* (void(^block)(UITextView* textView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidEndEditing
{
    return ^ UITextView* (void(^block)(UITextView* textView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextView* (^)(void(^block)(UITextView* textView,NSRange range,NSString* string)))sk_textViewShouldChangeTextInRange
{
    return ^ UITextView* (void(^block)(UITextView* textView,NSRange range,NSString* string)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidChange
{
    return ^ UITextView* (void(^block)(UITextView* textView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UITextView* (^)(void(^block)(UITextView* textView)))sk_textViewDidChangeSelection
{
    return ^ UITextView* (void(^block)(UITextView* textView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

@end
