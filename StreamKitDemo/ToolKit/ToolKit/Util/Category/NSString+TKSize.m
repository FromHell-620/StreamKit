//
//  NSString+TKSize.m
//  ToolKit
//
//  Created by DoubleHH on 15/11/9.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "NSString+TKSize.h"

@implementation NSString (TKSize)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    if (self.length == 0) {
        return CGSizeZero;
    }
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize strSize = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:stringAttributes context:nil].size;
        
        if (strSize.width > maxWidth) {
            strSize.width = maxWidth;
        }
        
        return CGSizeMake(ceil(strSize.width), ceil(strSize.height));
    }
    return CGSizeZero;
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font maxLineNum:(NSInteger)maxLine
{
    if (self.length == 0) {
        return CGSizeZero;
    }
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize strSize = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:stringAttributes context:nil].size;
        
        if (strSize.width > maxWidth) {
            strSize.width = maxWidth;
        }
        
        CGFloat maxLineHeight = ceilf(maxLine * font.lineHeight);
        if (strSize.height > maxLineHeight) {
            strSize.height = maxLineHeight;
        }
        return CGSizeMake(ceil(strSize.width), ceil(strSize.height));;
    }
    return CGSizeZero;
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font linespace:(CGFloat)linespace maxLine:(NSInteger)maxLine {
    if (self.length == 0) {
        return CGSizeZero;
    }
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = linespace;
        NSDictionary *stringAttributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
        CGSize strSize = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:stringAttributes context:nil].size;
        
        if (strSize.width > maxWidth) {
            strSize.width = maxWidth;
        }
        
        CGFloat maxLineHeight = ceilf(maxLine * font.lineHeight + linespace * (maxLine - 1));
        if (strSize.height > maxLineHeight) {
            strSize.height = maxLineHeight;
        }
        return CGSizeMake(ceil(strSize.width), ceil(strSize.height));;
    }
    return CGSizeZero;
}

- (CGSize)sizeWithMaxHeight:(CGFloat)maxHeight font:(UIFont *)font
{
    if (self.length == 0) {
        return CGSizeZero;
    }
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize strSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:stringAttributes context:nil].size;
        if (strSize.height > maxHeight) {
            strSize.height = maxHeight;
        }
        
        return CGSizeMake(ceil(strSize.width), ceil(strSize.height));;
    }
    return CGSizeZero;
}


@end
