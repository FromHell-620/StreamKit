//
//  ImageHelper.h
//  Find
//
//  Created by chunhui on 15/4/23.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ImageHelper : NSObject

+ (UIImage *)roundImage:(UIImage *)image;

+ (UIImage *)normImageOrientation:(UIImage *)image;

+ (UIImage *)resizeImage:(UIImage *)image maxWidth:(NSInteger)width;

+ (UIImage *)snapShotForView:(UIView *)view;

+ (UIImage *)subImageFor:(UIImage *)image inRegion:(CGRect)region;

+ (UIImage *)rotateImage:(UIImage *)image numberHalfPi:(NSInteger)num;

/*
 * image 获取二进制 数据
 * maxSize : 最大字节数 (bytes)
 *
 */
+ (NSData *)resizeImage:(UIImage *)image maxSize:(NSInteger)maxSize;

+ (void)saveToPhotosWithImage:(UIImage *)image;

+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size radius:(float)radius;

+ (NSData *)imageToData:(UIImage *)image;
@end
