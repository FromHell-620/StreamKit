//
//  TKKeyboardCommon.h
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#ifndef TKKeyboardCommon_h
#define TKKeyboardCommon_h

typedef NS_ENUM(NSInteger , TKKeyboardMode) {
    TKKeyboardModeText = 0 ,
    TKKeyboardModeEmoji ,
    TKKeyboardModeOther ,
    TKKeyboardModeNone ,
};

typedef NS_ENUM(NSInteger , TKKeyboardBarMode) {
    TKKeyboardBarModeDefault = 0 ,
    TKKeyboardBarModeTextOnly = 1,
};

#endif /* TKKeyboardCommon_h */
