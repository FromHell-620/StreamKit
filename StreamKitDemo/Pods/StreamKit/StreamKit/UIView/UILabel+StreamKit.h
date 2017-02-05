//
//  UILabel+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UILabel (StreamSuper)

- (UILabel* (^)(NSInteger tag))sk_tag;

- (UILabel* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UILabel* (^)(CGRect frame))sk_frame;

- (UILabel* (^)(CGFloat x))sk_x;

- (UILabel* (^)(CGFloat y))sk_y;

- (UILabel* (^)(CGFloat width))sk_width;

- (UILabel* (^)(CGFloat height))sk_height;

- (UILabel* (^)(CGSize size))sk_size;

- (UILabel* (^)(CGRect bounds))sk_bounds;

- (UILabel* (^)(CGPoint point))sk_center;

- (UILabel* (^)(CGFloat centerX))sk_centerX;

- (UILabel* (^)(CGFloat centerY))sk_centerY;

- (UILabel* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UILabel* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UILabel* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UILabel* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UILabel* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UILabel* (^)(CGFloat alpha))sk_alpha;

- (UILabel* (^)(BOOL opaque))sk_opaque;

- (UILabel* (^)(BOOL hidden))sk_hidden;

- (UILabel* (^)(UIViewContentMode mode))sk_contentMode;

- (UILabel* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UILabel* (^)(UIColor* tintColor))sk_tintColor;

- (UILabel* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer;

- (UILabel* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer;

- (UILabel* (^)(dispatch_block_t block))sk_addSimpleClickAction;

- (UILabel* (^)(void(^block)(__kindof UIView* view)))sk_addParamClickAction;

@end

@interface UILabel (StreamKit)

/**
 Creates a new label by the given frame.
 @code
 UILabel* label = UILabel.sk_init(frame);
 @endcode
 */
+ (UILabel* (^)(CGRect frame))sk_init;

/**
 Set text.
 @code
 self.sk_text(text);
 @endcode
 */
- (UILabel* (^)(NSString* text))sk_text;

/**
 Set textColor.
 @code
 self.sk_textColor(textColor);
 @endcode
 */
- (UILabel* (^)(UIColor* textColor))sk_textColor;

/**
 Set font.
 @code
 self.sk_fontSize(fontSize);
 @endcode
 */
- (UILabel* (^)(NSInteger fontSize))sk_fontSize;

/**
 Set font.
 @code
 self.sk_font(font);
 @endcode
 */
- (UILabel* (^)(UIFont* font))sk_font;

/**
 Set textAlignment.
 @code
 self.sk_textAlignment(textAlignment);
 @endcode
 */
- (UILabel* (^)(NSTextAlignment textAlignment))sk_textAlignment;

/**
 Set lineBreakMode.
 @code
 self.sk_lineBreakMode(lineBreakMode);
 @endcode
 */
- (UILabel* (^)(NSLineBreakMode lineBreakMode))sk_lineBreakMode;

/**
 Set attributedString.
 @code
 self.sk_attributedString(attributedString);
 @endcode
 */
- (UILabel* (^)(NSAttributedString* attributedString))sk_attributedString;

/**
 Set numberOfLines.
 @code
 self.sk_numberOfLines(numberOfLines);
 @endcode
 */
- (UILabel* (^)(NSInteger numberOfLines))sk_numberOfLines;

/**
 Set highlightedTextColor.
 @code
 self.sk_highlightedTextColor(highlightedTextColor);
 @endcode
 */
- (UILabel* (^)(UIColor* highlightedTextColor))sk_highlightedTextColor;

/**
 Set highlighted.
 @code
 self.sk_highlighted(highlighted);
 @endcode
 */
- (UILabel* (^)(BOOL highlighted))sk_highlighted;

/**
 Set minimumScaleFactor.
 @code
 self.sk_minimumScaleFactor(minimumScaleFactor);
 @endcode
 */
- (UILabel* (^)(CGFloat minimumScaleFactor))sk_minimumScaleFactor;

/**
 Set adjustsFontSizeToFitWidth.
 @code
 self.sk_adjustsFontSizeToFitWidth(adjustsFontSizeToFitWidth);
 @endcode
 */
- (UILabel* (^)(BOOL adjustsFontSizeToFitWidth))sk_adjustsFontSizeToFitWidth;

/**
 Set baselineAdjustment.
 @code
 self.sk_baselineAdjustment(baselineAdjustment);
 @endcode
 */
- (UILabel* (^)(UIBaselineAdjustment baselineAdjustment))sk_baselineAdjustment;


@end
