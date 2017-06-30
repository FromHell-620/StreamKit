//
//  NSAttributedString+TKSize.h
//  ToolKit
//
//  Created by chunhui on 15/12/4.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (TKSize)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;

- (CGSize)sizeWithMaxHeight:(CGFloat)maxHeight font:(UIFont *)font;

/**
 *  计算给定的高度
 *
 *  @param maxWidth 最大宽度
 *  @param font     字体大小，若富文本里面设置该项，则该项传空
 *  @param maxLine  最大行数
 *
 *  @return
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font maxLineNum:(NSInteger)maxLine;

@end
