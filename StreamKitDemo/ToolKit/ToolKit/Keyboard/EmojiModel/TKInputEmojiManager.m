//
//  TKInputEmojiManager.m
//  ToolKit
//
//  Created by chunhui on 16/4/20.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKInputEmojiManager.h"
@import UIKit;

static NSString* emotionBundlePath()
{
    static NSString* __emotionBundlePath;
    if( __emotionBundlePath == nil )
        __emotionBundlePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"emotion.bundle"];
    return __emotionBundlePath;
}

@interface TKInputEmojiManager ()

/*
 *   [[emotions],[emotions]]
 */
@property(nonatomic , strong) NSArray *allEmotions;

@end

@implementation TKInputEmojiManager


+(instancetype)sharedInstance
{
    static TKInputEmojiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKInputEmojiManager alloc]init];
    });
    return manager;
}

/**
 *  键盘中的删除项
 *
 *  @return
 */
+(TKInputEmojiItem *)deleteEmojiItem
{
    TKInputEmojiItem *item = [[TKInputEmojiItem alloc]init];
    NSString *bundlePath = emotionBundlePath();
    NSString *extraPath = [bundlePath stringByAppendingPathComponent:@"extra"];
    NSString *path = [extraPath stringByAppendingPathComponent:@"keyboard_remove@2x.png"];
    
    item.image = [UIImage imageWithContentsOfFile:path];
    item.name = nil;
    
    return item;
}

+(UIImage *)faceImage
{
    static UIImage *faceImage = nil;
    if (!faceImage) {
        NSString *bundlePath = emotionBundlePath();
        NSString *extraPath = [bundlePath stringByAppendingPathComponent:@"extra"];
        NSString *path = [extraPath stringByAppendingPathComponent:@"keyboard_face@2x.png"];
        faceImage = [UIImage imageWithContentsOfFile:path];
    }
    
    return faceImage;
}

+(UIImage *)keyboardImage
{
    static UIImage *keyboardImage = nil;
    if (!keyboardImage) {
        NSString *bundlePath = emotionBundlePath();
        NSString *extraPath = [bundlePath stringByAppendingPathComponent:@"extra"];
        NSString *path = [extraPath stringByAppendingPathComponent:@"keyboard_keyboard@2x.png"];
        keyboardImage = [UIImage imageWithContentsOfFile:path];
    }
    return keyboardImage;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *bundlePath = emotionBundlePath();
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"info.txt"];
        NSString *info = [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:nil];
        NSArray *emoTypes = [info componentsSeparatedByString:@"\n"];
        NSMutableArray *allEmotions = [[NSMutableArray alloc]init];
        for (NSString *dirPath in emoTypes) {
            
            NSMutableArray *emotions = [[NSMutableArray alloc]init];
            NSString *emoPath = [bundlePath stringByAppendingPathComponent:dirPath];
            NSString *listPath = [emoPath stringByAppendingPathComponent:@"list.txt"];
            NSString *content = [NSString stringWithContentsOfFile:listPath encoding:NSUTF8StringEncoding error:nil];
            NSString *emoImagesPath = [emoPath stringByAppendingPathComponent:@"emo"];
            
            NSArray *names = [content componentsSeparatedByString:@"\n"];
            TKInputEmojiItem *item = nil;
            for (NSString *name in names) {
                NSString *imgpath = [emoImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
                item = [[TKInputEmojiItem alloc]init];
                item.imgName = name;
                item.image = [UIImage imageWithContentsOfFile:imgpath];
                item.name = [NSString stringWithFormat:@"[%@]",name];
                
                [emotions addObject:item];
            }
            
            [allEmotions addObject:emotions];
        }
        
        self.allEmotions = allEmotions;
        
    }
    return self;
}

-(TKInputAttachment *)attachmentForName:(NSString *)name
{
    if (![name hasPrefix:@"["]) {
        name = [NSString stringWithFormat:@"[%@]",name];
    }
    TKInputAttachment *attachment  = [[TKInputAttachment alloc]init];
    for (NSArray *emotions in self.allEmotions) {
        
        for (TKInputEmojiItem *item in emotions) {
            if ([item.name isEqualToString:name]) {
                attachment.image = item.image;
                attachment.emojiName = item.name;
            }
        }
    }
    
    return attachment;
}

-(NSAttributedString *)toEmojiWithString:(NSString *)source andFont:(UIFont *)font
{
    return [self toEmojiWithString:source andFont:font emojiScale:1.0];
}

-(NSAttributedString *)toEmojiWithString:(NSString *)source andFont:(UIFont *)font emojiScale:(CGFloat)scale
{
    if (source.length == 0 ) {
        return nil;
    }
    if (font == nil) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    UIColor *textColor = [UIColor blackColor];
    
    NSScanner *theScanner = nil;
    NSString *text = nil;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    
    
    NSRange prange = [source rangeOfString:@"["];
    if (prange.location == NSNotFound) {//没有自定义表情
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:source attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        [attributeString appendAttributedString:str];
        return attributeString;
    }
    
    theScanner = [NSScanner scannerWithString:source];
    while (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"[" intoString:&text];//截取"["之前字符
        if (text && ![text isEqualToString:@"]"] && (text.length > 0)) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
            [attributeString appendAttributedString:str];
        }
        
        text = nil;
        [theScanner scanUpToString:@"]" intoString:&text];//取得"[]"之间字符
        if (text && ![text isEqualToString:@"]"] && (text.length > 0)) {
            //text = [aa
            TKInputAttachment *attach = [self attachmentForName:[text substringFromIndex:1]];
            
            if (attach.image && attach.image.size.width > 1.0f) {
                
                CGFloat width = ceil(font.lineHeight *scale);
                attach.bounds = CGRectMake(0, ceil(font.descender*2)/2, width ,width );
                
                NSAttributedString * attchString = [NSAttributedString attributedStringWithAttachment:attach];
                [attributeString appendAttributedString:attchString];
                
            }else{
                
                if (theScanner.scanLocation < source.length) {
                    //[xx] xx表情不支持 直接明文显示
                    text = [text stringByAppendingString:@"]"];
                }/*
                  else{
                  //没有 ] ,不显示表情
                  }
                  */
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
                [attributeString appendAttributedString:str];
                
            }
//        }else{
        }
        text = nil;
        [theScanner scanString: @"]" intoString: NULL];
    }
    if (attributeString.length > 0) {
        [attributeString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(attributeString.length -1 , 1)];
    }
    return attributeString;
}

/**
 *  解转义表情符号到字符串
 *
 *  @param attributeText 带表情的富文本
 *
 *  @return
 */
-(NSString *)unescapeEmoji:(NSAttributedString *)attributeText
{
    if (attributeText.length == 0) {
        return @"";
    }
    NSMutableAttributedString *muEmoji = [[NSMutableAttributedString alloc]initWithAttributedString:attributeText];
    [attributeText enumerateAttributesInRange:NSMakeRange(0, attributeText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[@"NSAttachment"]) {
            TKInputAttachment *attachment = attrs[@"NSAttachment"];
            if ([attachment isKindOfClass:[TKInputAttachment class]]) {
                [muEmoji replaceCharactersInRange:range withString:attachment.emojiName];
            }
        }
    }];
    
    return [muEmoji string];

}

@end


@implementation TKInputEmojiItem

@end
