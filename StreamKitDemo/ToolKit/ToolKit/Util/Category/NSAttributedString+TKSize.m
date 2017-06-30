//
//  NSAttributedString+TKSize.m
//  ToolKit
//
//  Created by chunhui on 15/12/4.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "NSAttributedString+TKSize.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (TKSize)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font{
    if (self.length == 0) {
        return CGSizeZero;
    }
    NSMutableAttributedString *mstring = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    if (font) {
        [mstring addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    }
    
    CGRect rect = [mstring boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return  CGSizeMake(ceilf(rect.size.width), ceil(rect.size.height));
}

- (CGSize)sizeWithMaxHeight:(CGFloat)maxHeight font:(UIFont *)font{
    
    if (self.length == 0) {
        return CGSizeZero;
    }
    NSMutableAttributedString *mstring = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    if (font) {
        [mstring addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    }
    
    CGRect rect = [mstring boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return  CGSizeMake(ceilf(rect.size.width), ceil(rect.size.height));
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font maxLineNum:(NSInteger)maxLine
{
    if (self.length == 0) {
        return CGSizeZero;
    }
    
    static UILabel *label = nil;
    if (label == nil) {
        label = [[UILabel alloc]init];
    }
    
    NSMutableAttributedString *mstring = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    if (font) {
        [mstring addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    }
    
    if (maxLine > 0) {
        label.numberOfLines = maxLine;
    }else{
        label.numberOfLines = 0;
    }
    
    label.attributedText = mstring;
    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    
    return size;
    
}

@end

