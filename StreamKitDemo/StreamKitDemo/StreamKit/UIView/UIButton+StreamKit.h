//
//  UIButton+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UIButton (StreamSuper)

#pragma mark- UIView
- (UIButton* (^)(CGRect frame))sk_frame;

- (UIButton* (^)(CGFloat x))sk_x;

- (UIButton* (^)(CGFloat y))sk_y;

- (UIButton* (^)(CGFloat width))sk_width;

- (UIButton* (^)(CGFloat height))sk_height;

- (UIButton* (^)(CGSize size))sk_size;

- (UIButton* (^)(CGRect bounds))sk_bounds;

- (UIButton* (^)(CGPoint point))sk_center;

- (UIButton* (^)(CGFloat centerX))sk_centerX;

- (UIButton* (^)(CGFloat centerY))sk_centerY;

- (UIButton* (^)(NSInteger tag))sk_tag;

- (UIButton* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UIButton* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UIButton* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UIButton* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UIButton* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UIButton* (^)(CGFloat alpha))sk_alpha;

- (UIButton* (^)(BOOL opaque))sk_opaque;

- (UIButton* (^)(BOOL hidden))sk_hidden;

- (UIButton* (^)(UIViewContentMode mode))sk_contentMode;

- (UIButton* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UIButton* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIControl

- (UIButton* (^)(BOOL enabled))sk_enabled;

- (UIButton* (^)(BOOL selected))sk_selected;

- (UIButton* (^)(BOOL highlighted))sk_highlighted;

- (UIButton* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment;

- (UIButton* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment;

- (UIButton* (^)(UIControlEvents controlEvents,void(^block)(__kindof UIButton* target)))sk_addEventBlock;

- (UIButton* (^)(UIControlEvents controlEvents))sk_removeEventBlock;

- (UIButton* (^)())sk_removeAllEventBlock;

@end

@interface UIButton (StreamKit)

/**
 Creates a new button and the type is 'UIButtonTypeCustom'.
 @code
 UIButton* button = UIButton.sk_initWithFrame(frame);
 @endcode
 @return a block which receive a frame
 */
+ (UIButton* (^)(CGRect frame))sk_initWithFrame;

/**
 Creates a new button with the specified type.
 @code
 UIButton* button = UIButton.sk_initWithType(type);
 @endcode
 @return a block which receive a buttonType.
 */
+ (UIButton* (^)(UIButtonType buttonType))sk_initWithType;

/**
 Set titleFont
 @code
 self.sk_setFont(font);
 @endcode
 */
- (UIButton* (^)(UIFont* font))sk_setFont;

/**
 Set titleFont
 @code
 self.sk_setFontSize(fontSize);
 @endcode
 */
- (UIButton* (^)(NSInteger fontSize))sk_setFontSize;

/**
 Set titleEdgeInsets.
 @code
 self.sk_titleEdgeInsets(titleEdgeInsets);
 @endcode
 */
- (UIButton* (^)(UIEdgeInsets titleEdgeInsets))sk_titleEdgeInsets;

/**
 Set imageEdgeInsets.
 @code
 self.sk_imageEdgeInsets(imageEdgeInsets).
 @endcode
 */
- (UIButton* (^)(UIEdgeInsets imageEdgeInsets))sk_imageEdgeInsets;

/**
 Set normal title.
 @code
 self.sk_setTitleNormal(title);
 @endcode
 */
- (UIButton* (^)(NSString* title))sk_setTitleNormal;

/**
 Set highlight title.
 @code
 self.sk_setTitleHighlight(title);
 @endcode
 */
- (UIButton* (^)(NSString* title))sk_setTitleHighlight;

/**
 Set select title.
 @code
 self.sk_setTitleSelect(title);
 @endcode
 */
- (UIButton* (^)(NSString* title))sk_setTitleSelect;

/**
 Set state title.
 @code
 self.sk_setTitle(title,state);
 @endcode
 */
- (UIButton* (^)(NSString* title,UIControlState state))sk_setTitle;

/**
 Set normal titleColor
 @code
 self.sk_setTitleColorNormal(titleColor);
 @endcode
 */
- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorNormal;

/**
 Set hightlight titleColor
 @code
 self.sk_setTitleColorHightlight(titleColor);
 @endcode
 */
- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorHightlight;

/**
 Set select titleColor
 @code
 self.sk_setTitleColorSelect(titleColor);
 @endcode
 */
- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorSelect;

/**
 Set state titleColor
 @code
 self.sk_setTitleColor(titleColor,state);
 @endcode
 */
- (UIButton* (^)(UIColor* titleColor,UIControlState state))sk_setTitleColor;

/**
 Set normal attributedString.
 @code
 self.sk_setAttributedStringNormal(attributedString);
 @endcode
 */
- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringNormal;

/**
 Set hightlight attributedString.
 @code
 self.sk_setAttributedStringHightlight(attributedString);
 @endcode
 */
- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringHightlight;

/**
 Set select attributedString.
 @code
 self.sk_setAttributedStringSelect(attributedString);
 @endcode
 */
- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringSelect;

/**
 Set state attributedString.
 @code
 self.sk_setAttributedString(attributedString,state);
 @endcode
 */
- (UIButton* (^)(NSAttributedString* attributedString,UIControlState state))sk_setAttributedString;

/**
 Set normal image.
 @code
 self.sk_setImageNormal(image);
 @endcode
 */
- (UIButton* (^)(UIImage* image))sk_setImageNormal;

/**
 Set hightlight image.
 @code
 self.sk_setImageHightlight(image);
 @endcode
 */
- (UIButton* (^)(UIImage* image))sk_setImageHightlight;

/**
 Set select image.
 @code
 self.sk_setImageSelect(image);
 @endcode
 */
- (UIButton* (^)(UIImage* image))sk_setImageSelect;

/**
 Set state image
 @code
 self.sk_setImage(image,state);
 @endcode
 */
- (UIButton* (^)(UIImage* image,UIControlState state))sk_setImage;

/**
 Set normal backgroundImage.
 @code
 self.sk_setBackgroundImageNormal(image);
 @endcode
 */
- (UIButton* (^)(UIImage* image))sk_setBackgroundImageNormal;

/**
 Set hightlight backgroundImage.
 @code
 self.sk_setBackgroundImageHightlight(image);
 @endcode
 */
- (UIButton* (^)(UIImage* image))sk_setBackgroundImageHightlight;

/**
 Set select backgroundImage
 @code
 self.sk_setBackgroundImageSelect(image);
 @endcode
 */
- (UIButton* (^)(UIImage* image))sk_setBackgroundImageSelect;

/**
 Set state backgroundImage
 @code
 self.sk_setBackgroundImage(image,state);
 @endcode
 */
- (UIButton* (^)(UIImage* image,UIControlState state))sk_setBackgroundImage;

@end
