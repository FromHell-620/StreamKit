//
//  TKInputEmojiManager.h
//  ToolKit
//
//  Created by chunhui on 16/4/20.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKInputAttachment.h"
@class UIImage;

@interface TKInputEmojiItem : NSObject

@property(nonatomic , strong) UIImage *image;   //表情图片
@property(nonatomic , copy)   NSString *name;   //表情显示名称
@property(nonatomic , copy)   NSString *imgName;//表情对应图片的名称

@end


@interface TKInputEmojiManager : NSObject

@property(nonatomic , strong , readonly) NSArray *allEmotions;

+(instancetype)sharedInstance;
/**
 *  键盘中的删除项
 *
 *  @return
 */
+(TKInputEmojiItem *)deleteEmojiItem;

+(UIImage *)faceImage;

+(UIImage *)keyboardImage;

-(TKInputAttachment *)attachmentForName:(NSString *)name;

/**
 *  转换成attribute string ， emoji按1.0放大
 *
 *  @param source 字符串
 *  @param font   字体
 *
 *  @return
 */
-(NSAttributedString *)toEmojiWithString:(NSString *)source andFont:(UIFont *)font;

/**
 *  转换成attribute string ， emoji按scale放大
 *
 *  @param source 字符串
 *  @param font   字体
 *  @param scale  放大倍数
 *
 *  @return
 */
-(NSAttributedString *)toEmojiWithString:(NSString *)source andFont:(UIFont *)font emojiScale:(CGFloat)scale;

/**
 *  解转义表情符号到字符串
 *
 *  @param attributeText 带表情的富文本
 *
 *  @return
 */
-(NSString *)unescapeEmoji:(NSAttributedString *)attributeText;

@end
