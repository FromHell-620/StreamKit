//
//  NSString+TKSize.h
//  ToolKit
//
//  Created by DoubleHH on 15/11/9.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TKSize)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font maxLineNum:(NSInteger)maxLine;

- (CGSize)sizeWithMaxHeight:(CGFloat)maxHeight font:(UIFont *)font;

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font linespace:(CGFloat)linespace maxLine:(NSInteger)maxLine;

@end
