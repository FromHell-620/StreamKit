//
//  TKInputTextView.m
//  ToolKit
//
//  Created by chunhui on 16/4/21.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKInputTextView.h"
#import "TKInputEmojiManager.h"

@implementation TKInputTextView

-(void)paste:(id)sender
{
    if (_pasteDelegate) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        NSString *content = pboard.string;
        if (content.length > 0) {
            [super paste:sender];
            pboard.string = @" ";
            [self.pasteDelegate pasteContent:content];
            pboard.string = content;
        }
    }else{
        [super paste:sender];
    }
}

-(NSAttributedString *)toEmojiString:(NSString *)source
{
    NSScanner *theScanner;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    NSString *text = nil;
    
    UIColor *textColor = self.textColor;
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    
    NSRange prange = [source rangeOfString:@"["];
    if (prange.location == NSNotFound) {//没有自定义表情
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:source attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:textColor}];
        [attributeString appendAttributedString:str];
        return attributeString;
    }
    
    theScanner = [NSScanner scannerWithString:source];
    while (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"[" intoString:&text];//截取"["之前字符
        if (text && ![text isEqualToString:@"]"] && (text.length > 0)) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:textColor}];
            [attributeString appendAttributedString:str];
        }
        
        text = nil;
        [theScanner scanUpToString:@"]" intoString:&text];//取得"[]"之间字符
        if (text && ![text isEqualToString:@"]"] && (text.length > 0)) {
            //text = [aa
            TKInputAttachment *attach = [[TKInputEmojiManager sharedInstance]attachmentForName:[text substringFromIndex:1]];
            
            if (attach.image && attach.image.size.width > 1.0f) {

                CGFloat width = ceil(self.font.lineHeight);
                attach.bounds = CGRectMake(0, ceil(self.font.descender*2)/2, width ,width );

                NSAttributedString * attchString = [NSAttributedString attributedStringWithAttachment:attach];
                [attributeString appendAttributedString:attchString];
                
            }
        }
        text = nil;
        [theScanner scanString: @"]" intoString: NULL];
    }
    if (attributeString.length > 0) {
        [attributeString addAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(attributeString.length -1 , 1)];
    }
    return attributeString;
}

-(void)setText:(NSString *)text
{
    if (text.length > 0) {
        NSAttributedString *attr = [self toEmojiString:text];
        [super setAttributedText:attr];
    }else{
        [super setText:text];
    }    
}

-(NSString *)plainText
{
    
    NSRange range = NSMakeRange(0, self.attributedText.length);
    NSMutableAttributedString *result = [self.attributedText mutableCopy];
    
    [result enumerateAttribute:NSAttachmentAttributeName inRange:range options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && [value isKindOfClass:[TKInputAttachment class]]) {
            TKInputAttachment *attach = (TKInputAttachment *)value;
            [result deleteCharactersInRange:range];
            [result insertAttributedString:[[NSAttributedString alloc] initWithString:attach.emojiName] atIndex:range.location];
        }
    }];
    
    return result.string;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
