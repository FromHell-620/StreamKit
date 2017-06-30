//
//  ImageHelper.m
//  Find
//
//  Created by chunhui on 15/4/23.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *)roundImage:(UIImage *)image {
    UIImage *toImage = nil;
    
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    
    CGFloat width =  imageWidth;
    
    
    if (width <= 0 ){
        return toImage;
    }
    
    CGRect drawRect ;
    if (imageWidth > imageHeight) {
        width = imageHeight;
        drawRect = CGRectMake(-(imageWidth - imageHeight)/2, 0,imageWidth , imageHeight);
    }else{
        drawRect = CGRectMake(0, -(imageHeight - imageWidth)/2, imageWidth, imageHeight);
    }
    
    CGRect rect = CGRectMake(0, 0, width, width);
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:drawRect];
    toImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return toImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)roundedImageWithImage:(UIImage*)image radius:(CGFloat)r {
    int w = image.size.width;
    int h = image.size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, bitmapInfo);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *i = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return i;
}

+ (UIImage *)normImageOrientation:(UIImage *)aImage {
    if (aImage == nil) {
        return aImage;
    }    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)rotateImage:(UIImage *)image numberHalfPi:(NSInteger)num {
    
    if (image == nil) {
        return image;
    }
    
    CGFloat rotate = num*M_PI_2;
    
    CGSize imgSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
    CGSize outputSize = imgSize;
    if (num%2) {
        outputSize = CGSizeMake(imgSize.height, imgSize.width);
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *toImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return toImage;
}

+ (UIImage *)resizeImage:(UIImage *)image maxWidth:(NSInteger)width {
    
    if (image == nil) {
        return nil;
    }
    
    
    CGImageRef sourceImage = [image CGImage];
    //    width = [[UIScreen mainScreen]scale]*width;
    
    CGFloat targetWidth = CGImageGetWidth(sourceImage);
    CGFloat targetHeight ;
    if (targetWidth > width) {
        targetHeight = CGImageGetHeight(sourceImage)*(width / targetWidth);
        targetWidth =  width;
    }else{
        image = [self normImageOrientation:image];
        return image;
    }
    
//    UIImageOrientation imageOrientation = image.imageOrientation;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, targetHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, targetWidth, targetHeight), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(sourceImage);
//    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(sourceImage);
//    
//    size_t bytePerRow = CGImageGetBytesPerRow(sourceImage)/CGImageGetWidth(sourceImage);
//    
//    CGContextRef bitmap = CGBitmapContextCreate(NULL, (size_t)targetWidth, (size_t)targetHeight, CGImageGetBitsPerComponent(sourceImage), targetWidth*bytePerRow, colorSpaceInfo, bitmapInfo);
//    
//    CGContextDrawImage(bitmap, CGRectMake(0, 0, (size_t)targetWidth, (size_t)targetHeight), sourceImage);
//    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
//    CGContextRelease(bitmap);
//    
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    CGImageRelease(newImageRef);
//    
//    return newImage;
    
}

+ (UIImage *)snapShotForView:(UIView *)view {
    CALayer *layer = view.layer;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [[UIScreen mainScreen]scale]);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)subImageFor:(UIImage *)image inRegion:(CGRect)region {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, region);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size,YES,image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return smallImage;
    
}

+ (NSData *)resizeImage:(UIImage *)image maxSize:(NSInteger)maxSize {
    @autoreleasepool {
        CGFloat quality = 0.8;
        NSData *data = nil;
        do{
            data = UIImageJPEGRepresentation(image, quality);
        }while (data.length > maxSize);
        return data;
    }
}


+ (void)saveToPhotosWithImage:(UIImage*)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    } else {
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
}

+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color size:size radius:0];
}

+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size radius:(float)radius {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        if (radius > 0.01) {
            colorImage = [self roundedImageWithImage:colorImage radius:radius];
        }
        return colorImage;
    }
}

+ (NSData *)imageToData:(UIImage *)image {
    @autoreleasepool {
        NSData *data = UIImagePNGRepresentation(image);
        if (data == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        }
        return data;
    }
}

@end
