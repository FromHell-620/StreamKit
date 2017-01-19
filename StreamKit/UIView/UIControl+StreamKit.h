//
//  UIControl+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/15.
//  Copyright © 2016年 苏南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (StreamKit)

/**
 Set enabled.
 @code
 self.sk_enabled(enabled);
 @endcode
 */
- (UIControl* (^)(BOOL enabled))sk_enabled;

/**
 Set selected.
 @code
 self.sk_selected(selected);
 @endcode
 */
- (UIControl* (^)(BOOL selected))sk_selected;

/**
 Set hightlighted.
 @code
 self.sk_highlighted(highlighted);
 @endcode
 */
- (UIControl* (^)(BOOL highlighted))sk_highlighted;

/**
 Set contentVerticalAlignment.
 @code
 self.sk_contentVerticalAlignment(contentVerticalAlignment);
 @endcode
 */
- (UIControl* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment;

/**
 Set contentHorizontalAlignment.
 @code
 self.sk_contentHorizontalAlignment(contentHorizontalAlignment);
 @endcode
 */
- (UIControl* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment;

/**
 Adds an event block to the control.
 @code
 self.sk_addEventBlock(controlEvents,^(UIControl* control){
    your code;
 });
 @endcode
 @return a block which receive a controlEvents and a event block.
         the event block is invoked when the action message is sent.
 */
- (UIControl* (^)(UIControlEvents controlEvents,void(^block)(__kindof UIControl* target)))sk_addEventBlock;

/**
 Remove the event block by the given controlEvents.
 @code
 self.sk_removeEventBlock(controlEvents);
 @endcode
 */
- (UIControl* (^)(UIControlEvents controlEvents))sk_removeEventBlock;

/**
 Remove all event blocks of the control.
 @code
 self.sk_removeAllEventBlock();
 @endcode
 */
- (UIControl* (^)())sk_removeAllEventBlock;

@end
