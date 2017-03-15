//
//  UISwitch+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (StreamKit)

/**
 Creates a new switch by the given frame.
 @code
 UISwitch* switch = UISwitch.sk_init(frame);
 @endcode
 */
+ (UISwitch* (^)(CGRect frame))sk_init;

/**
 Set onTintColor.
 @code
 self.sk_onTintColor(onTintColor);
 @endcode
 */
- (UISwitch* (^)(UIColor* onTintColor))sk_onTintColor;

/**
 Set tintColor.
 @code
 self.sk_tintColor(tintColor);
 @endcode
 */
- (UISwitch* (^)(UIColor* tintColor))sk_tintColor;

/**
 Set thumbTintColor.
 @code
 self.sk_thumbTintColor(thumbTintColor);
 @endcode
 */
- (UISwitch* (^)(UIColor* thumbTintColor))sk_thumbTintColor;

/**
 Set onImage.
 @code
 self.sk_onImage(onImage);
 @endcode
 */
- (UISwitch* (^)(UIImage* onImage))sk_onImage;

/**
 Set offImage.
 @code
 self.sk_offImage(offImage);
 @endcode
 */
- (UISwitch* (^)(UIImage* offImage))sk_offImage;

/**
 Set on.
 @code
 self.sk_on(on);
 @endcode
 */
- (UISwitch* (^)(BOOL on))sk_on;

/**
 Set on.
 @code
 self.sk_setOnWithAnimaled(on,animaled);
 @endcode
 */
- (UISwitch* (^)(BOOL on,BOOL animaled))sk_setOnWithAnimaled;

@end
