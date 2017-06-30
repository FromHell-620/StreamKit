//
//  FSZoomImageView.h
//  FSPhotoBrowser
//
//  Created by Fengshan.yang on 14-2-17.
//  Copyright (c) 2014年 Fanyi Network techonology Co.,Ltd. All rights reserved.
//

#define FS_ZOOM_IMAGE_SCROLL_VIEW_GAP_WIDTH 10.0f //  The gap between two photos.

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class ZoomScrollView;

typedef void (^ScrollZoomStateBlock) (BOOL normalState);

@interface FSZoomImageView : UIView
{
@private
    ZoomScrollView *_scrollView;
    CGFloat _zoomScale;
    UIImageView *_imageView;
    NSString *_imageUrl;
}
@property (nonatomic, readonly, strong) ZoomScrollView *scrollView;
@property (nonatomic, readonly, assign) CGFloat zoomScale;
@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, copy) dispatch_block_t didTapBlock;   //  did tap callback block
@property (nonatomic, copy) ScrollZoomStateBlock zoomStateBlock;    //  double click the scrollview will call this function.

//  recovery scrollview zoom scale
- (void)recoveryZoomScale;

/**
 *  @description
 *      Set the imageView 'image' with a 'url'.
 *  @params
 *      url     the image's url.
 */
- (void)setImageWithUrl:(NSString *)url;
- (void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)image;

-(void)setImageWithImage:(UIImage *)image;

-(void)animateImageView:(CGRect)fromRect;

@end

#pragma mark -
#pragma mark - ZoomScrollView

@interface ZoomScrollView : UIScrollView
{
@private
    UIView *_zoomView;
}

@property (nonatomic, strong) UIView *zoomView;

@end




