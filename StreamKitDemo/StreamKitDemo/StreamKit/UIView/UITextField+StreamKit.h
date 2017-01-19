//
//  UITextField+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UITextField (StreamSuper)

#pragma mark- UIView
- (UITextField* (^)(CGRect frame))sk_frame;

- (UITextField* (^)(CGFloat x))sk_x;

- (UITextField* (^)(CGFloat y))sk_y;

- (UITextField* (^)(CGFloat width))sk_width;

- (UITextField* (^)(CGFloat height))sk_height;

- (UITextField* (^)(CGSize size))sk_size;

- (UITextField* (^)(CGRect bounds))sk_bounds;

- (UITextField* (^)(CGPoint point))sk_center;

- (UITextField* (^)(CGFloat centerX))sk_centerX;

- (UITextField* (^)(CGFloat centerY))sk_centerY;

- (UITextField* (^)(NSInteger tag))sk_tag;

- (UITextField* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UITextField* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UITextField* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UITextField* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UITextField* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UITextField* (^)(CGFloat alpha))sk_alpha;

- (UITextField* (^)(BOOL opaque))sk_opaque;

- (UITextField* (^)(BOOL hidden))sk_hidden;

- (UITextField* (^)(UIViewContentMode mode))sk_contentMode;

- (UITextField* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UITextField* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIControl

- (UITextField* (^)(BOOL enabled))sk_enabled;

- (UITextField* (^)(BOOL selected))sk_selected;

- (UITextField* (^)(BOOL highlighted))sk_highlighted;

- (UITextField* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment;

- (UITextField* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment;

- (UITextField* (^)(UIControlEvents controlEvents,void(^block)(__kindof UITextField* target)))sk_addEventBlock;

- (UITextField* (^)(UIControlEvents controlEvents))sk_removeEventBlock;

- (UITextField* (^)())sk_removeAllEventBlock;

@end

@interface UITextField (StreamKit)

/**
 Creates a new textField by the given frame.
 @code
 UITextField* textField = UITextField.sk_init(frame);
 @endcode
 */
+ (UITextField* (^)(CGRect frame))sk_init;

/**
 Set text.
 @code
 self.sk_text(text);
 @endcode
 */
- (UITextField* (^)(NSString* text))sk_text;

/**
 Set attributedText.
 @code
 self.sk_attributedText(attributedText);
 @endcode
 */
- (UITextField* (^)(NSAttributedString* attributedText))sk_attributedText;

/**
 Set textColor.
 @code
 self.sk_textColor(textColor);
 @endcode
 */
- (UITextField* (^)(UIColor* textColor))sk_textColor;

/**
 Set font.
 @code
 self.sk_fontSize(fontSize);
 @endcode
 */
- (UITextField* (^)(NSInteger fontSize))sk_fontSize;

/**
 Set font.
 @code
 self.sk_font(font);
 @endcode
 */
- (UITextField* (^)(UIFont* font))sk_font;

/**
 Set textAlignment.
 @code
 self.sk_textAlignment(textAlignment);
 @endcode
 */
- (UITextField* (^)(NSTextAlignment textAlignment))sk_textAlignment;

/**
 Set borderStyle.
 @code
 self.sk_borderStyle(borderStyle);
 @endcode
 */
- (UITextField* (^)(UITextBorderStyle borderStyle))sk_borderStyle;

/**
 Set defaultTextAttributes.
 @code
 self.sk_defaultTextAttributes(defaultTextAttributes);
 @endcode
 */
- (UITextField* (^)(NSDictionary<NSString*,id>* defaultTextAttributes))sk_defaultTextAttributes;

/**
 Set placeholder.
 @code
 self.sk_placeholder(placeholder);
 @endcode
 */
- (UITextField* (^)(NSString* placeholder))sk_placeholder;

/**
 Set attributedPlaceholder.
 @code
 self.sk_attributedPlaceholder(attributedPlaceholder);
 @endcode
 */
- (UITextField* (^)(NSAttributedString* attributedPlaceholder))sk_attributedPlaceholder;

/**
 Set clearsOnBeginEditing.
 @code
 self.sk_clearsOnBeginEditing(clearsOnBeginEditing);
 @endcode
 */
- (UITextField* (^)(BOOL clearsOnBeginEditing))sk_clearsOnBeginEditing;

/**
 Set adjustsFontSizeToFitWidth.
 @code
 self.sk_adjustsFontSizeToFitWidth(adjustsFontSizeToFitWidth);
 @endcode
 */
- (UITextField* (^)(BOOL adjustsFontSizeToFitWidth))sk_adjustsFontSizeToFitWidth;

/**
 Set minimumFontSize.
 @code
 self.sk_minimumFontSize(minimumFontSize);
 @endcode
 */
- (UITextField* (^)(CGFloat minimumFontSize))sk_minimumFontSize;

/**
 Set delegate.
 @code
 self.sk_delegate(delegate);
 @endcode
 */
- (UITextField* (^)(id<UITextFieldDelegate> delegate))sk_delegate;

/**
 Set background.
 @code
 self.sk_background(background);
 @endcode
 */
- (UITextField* (^)(UIImage* background))sk_background;

/**
 Set disabledBackground.
 @code
 self.sk_disabledBackground(disabledBackground);
 @endcode
 */
- (UITextField* (^)(UIImage* disabledBackground))sk_disabledBackground;

/**
 Set allowsEditingTextAttributes.
 @code
 self.sk_allowsEditingTextAttributes(allowsEditingTextAttributes);
 @endcode
 */
- (UITextField* (^)(BOOL allowsEditingTextAttributes))sk_allowsEditingTextAttributes;

/**
 Set typingAttributes.
 @code
 self.sk_typingAttributes(typingAttributes);
 @endcode
 */
- (UITextField* (^)(NSDictionary<NSString*,id>* typingAttributes))sk_typingAttributes;

/**
 Set clearButtonMode.
 @code
 self.sk_clearButtonMode(clearButtonMode);
 @endcode
 */
- (UITextField* (^)(UITextFieldViewMode clearButtonMode))sk_clearButtonMode;

/**
 Set leftView.
 @code
 self.sk_leftView(leftView);
 @endcode
 */
- (UITextField* (^)(UIView* leftView))sk_leftView;

/**
 Set leftViewMode.
 @code
 self.sk_leftViewMode(leftViewMode);
 @endcode
 */
- (UITextField* (^)(UITextFieldViewMode leftViewMode))sk_leftViewMode;

/**
 Set rightView.
 @code
 self.sk_rightView(rightView);
 @endcode
 */
- (UITextField* (^)(UIView* rightView))sk_rightView;

/**
 Set rightViewMode.
 @code
 self.sk_rightViewMode(rightViewMode);
 @endcode
 */
- (UITextField* (^)(UITextFieldViewMode rightViewMode))sk_rightViewMode;

@end

@interface UITextField (StreamDelegate)

/**
 Instead of the 'textFieldShouldBeginEditing:'.
 @code
 self.sk_textFieldShouldBeginEditing(^BOOL(UITextField* textField){
    your code;
 });
 @endcode
 @return a block which receive a event block and you should invoke.
         the event block will invoke when the delegate methods execute.
 */
- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldBeginEditing;

/**
 Instead of the 'textFieldDidBeginEditing:'.
 @code
 self.sk_textFieldDidBeginEditing(^(UITextField* textField){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(void(^block)(UITextField* textField)))sk_textFieldDidBeginEditing;

/**
 Instead of the 'textFieldShouldEndEditing:'.
 @code
 self.sk_textFieldShouldEndEditing(^BOOL(UITextField* textField){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldEndEditing;

/**
 Instead of the 'textFieldDidEndEditing:'.
 @code
 self.sk_textFieldDidEndEditing(^(UITextField* textField){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(void(^block)(UITextField* textField)))sk_textFieldDidEndEditing;

/**
 Instead of the 'textFieldDidEndEditing:reason:'.
 @code
 self.sk_textFieldDidEndEditingWithReaseon(^(UITextField* textField,UITextFieldDidEndEditingReason reason){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(void(^block)(UITextField* textField,UITextFieldDidEndEditingReason reason)))sk_textFieldDidEndEditingWithReaseon;

/**
 Instead of the 'textField:shouldChangeCharactersInRange:replacementString:'.
 @code
 self.sk_textFieldShouldChangeCharactersInRange(^BOOL(UITextField* textField,NSRange range,NSString* string){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(BOOL(^block)(UITextField* textField,NSRange range,NSString* string)))sk_textFieldShouldChangeCharactersInRange;

/**
 Instead of the 'textFieldShouldClear:'.
 @code
 self.sk_textFieldShouldClear(^BOOL(UITextField* textField){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldClear;

/**
 Instead of the 'textFieldShouldReturn:'.
 @code
 self.sk_textFieldShouldReturn(^BOOL(UITextField* textField){
    your code;
 });
 @endcode
 */
- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldReturn;

@end
