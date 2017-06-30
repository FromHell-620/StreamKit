//
//  FSZoomImageView.m
//  FSPhotoBrowser
//
//  Created by Fengshan.yang on 14-2-17.
//  Copyright (c) 2014年 Fanyi Network techonology Co.,Ltd. All rights reserved.
//

#define SCROLL_VIEW_MAXIMUM_ZOOM_SCALE 3.0f
#define SCROLL_VIEW_MINIMUM_ZOOM_SCALE 1.0f
#define SCROLL_VIEW_INDICATOR_WIDTH 35.0f

#import "FSZoomImageView.h"

@interface FSZoomImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) ZoomScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSString *imageUrl;

@end

@implementation FSZoomImageView

#pragma mark -
#pragma mark - Life Cycle

- (void)dealloc
{
    self.scrollView = nil;
    _imageView = nil;
    self.didTapBlock = nil;
    self.zoomStateBlock = nil;
    self.indicator = nil;
    self.imageUrl = nil;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSelfView];
    }
    return self;
}

-(void)animateImageView:(CGRect)fromRect
{
//    CGRect frame = self.imageView.frame;
//    self.imageView.frame = fromRect;
//    [UIView animateWithDuration:0.35 animations:^{
//        self.imageView.frame = frame;
//    }];
    
    self.scrollView.frame = fromRect;
    
}

#pragma mark -
#pragma mark - Private Method

- (void)setupSelfView
{
    CGRect rect = [self bounds];
    rect.size.width = CGRectGetWidth([self bounds]);// - FS_ZOOM_IMAGE_SCROLL_VIEW_GAP_WIDTH;
    _scrollView = [[ZoomScrollView alloc] initWithFrame:rect];
    [_scrollView setDelegate:self];
    [_scrollView setMaximumZoomScale:SCROLL_VIEW_MAXIMUM_ZOOM_SCALE];
    [_scrollView setMinimumZoomScale:0];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 260.0f*CGRectGetWidth(rect)/320.0f)];
    _imageView.clipsToBounds = YES;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_scrollView setZoomView:_imageView];
    
    _zoomScale = CGRectGetWidth([_scrollView bounds]) / CGRectGetWidth([_imageView bounds]);
    [_scrollView setContentSize:[_imageView frame].size];
    [_scrollView setZoomScale:_zoomScale];
    [_scrollView setContentOffset:CGPointZero];

    [[self addTapGestureWithTagsRequired:1] requireGestureRecognizerToFail:[self addTapGestureWithTagsRequired:2]];

    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((CGRectGetWidth([self bounds]) - SCROLL_VIEW_INDICATOR_WIDTH - FS_ZOOM_IMAGE_SCROLL_VIEW_GAP_WIDTH) / 2, (CGRectGetHeight([self bounds]) - SCROLL_VIEW_INDICATOR_WIDTH - FS_ZOOM_IMAGE_SCROLL_VIEW_GAP_WIDTH) / 2, SCROLL_VIEW_INDICATOR_WIDTH, SCROLL_VIEW_INDICATOR_WIDTH)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:_indicator];
        
}

- (UITapGestureRecognizer *)addTapGestureWithTagsRequired:(NSInteger)required
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapGestureRecognizer:)];
    [tap setNumberOfTapsRequired:required];
    [self addGestureRecognizer:tap];
    return tap;
}

- (void)recoveryZoomScaleNotAnimated
{
    [_scrollView setZoomScale:_zoomScale];
    if (_zoomStateBlock) {
        _zoomStateBlock(YES);
    }
    [_indicator stopAnimating];
}

- (void)resetZoonScale
{
    if (_imageView.image == nil) {
        return;
    }
    
    CGSize size = [[_imageView image] size];
    
    if (size.width > CGRectGetWidth(self.bounds)){
        size.height *= (CGRectGetWidth(self.bounds)/size.width);
        size.width = CGRectGetWidth(self.bounds);
    }
    
    CGRect rect = [_imageView frame];
    rect.size = size;

    [_imageView setFrame:CGRectMake(CGRectGetMidX(_imageView.frame) - CGRectGetWidth(rect)/2, CGRectGetMidY(_imageView.frame) - CGRectGetHeight(rect)/2, size.width, size.height)];
    if (size.height < CGRectGetHeight(_scrollView.bounds)){
        size.height = _scrollView.bounds.size.height;
    }
    
    _zoomScale = CGRectGetWidth([_scrollView bounds]) / CGRectGetWidth([_imageView bounds]);
    [_scrollView setContentSize:size];
    [_scrollView setMinimumZoomScale:_zoomScale];
    [_scrollView setContentOffset:CGPointZero];

    [self performSelectorOnMainThread:@selector(recoveryZoomScaleNotAnimated) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark - Public Method

- (void)recoveryZoomScale
{
    [_scrollView setZoomScale:_zoomScale animated:NO];
    if (_zoomStateBlock) {
        _zoomStateBlock(YES);
    }
}

-(void)setImageWithImage:(UIImage *)image
{
    self.imageView.image = image;
    [self resetZoonScale];
}

- (void)setImageWithUrl:(NSString *)url
{
    [self setImageWithUrl:url placeHolder:nil];
}
- (void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)image
{
    if (_imageUrl == url || [_imageUrl isEqualToString:url]) {
        return;
    }

    _imageUrl = url;

    [self startRotateIndicator];

    __block typeof(self) __weak myself = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]
               placeholderImage:image
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          [myself resetZoonScale];
                          if (error) {
#if DEBUG
                              NSLog(@"\n\n load browser image failed\n%@\n\n",error);
#endif
                          }
                          
    }];
}

- (void)startRotateIndicator
{
    [_indicator startAnimating];
}

#pragma mark -
#pragma mark - @ - selector

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if ([tap numberOfTapsRequired] == 1) {
        //  single
        if (_didTapBlock) {
            _didTapBlock();
        }
    } else if ([tap numberOfTapsRequired] == 2) {
        //  double
        CGFloat scale = [_scrollView zoomScale];
        if (scale > _zoomScale) {
            scale = _zoomScale;
        } else {
            scale = _zoomScale * 2;
        }
        [_scrollView setZoomScale:scale animated:YES];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    BOOL state = NO;
    if (scale < _zoomScale * 1.2) {
        state = YES;
    }
    if (_zoomStateBlock) {
        _zoomStateBlock(state);
    }
}

#pragma mark -
#pragma mark - CTImageViewDelegate

- (void)imageViewLoadImageSucceed:(id)imageView
{
    CGSize size = [[imageView image] size];
    size.height = size.height;
    size.width = size.width;
    CGRect rect = [_imageView frame];
    rect.size = size;
    [_imageView setFrame:rect];

    _zoomScale = CGRectGetWidth([_scrollView bounds]) / CGRectGetWidth([_imageView bounds]);
    [_scrollView setContentSize:size];
    [_scrollView setMinimumZoomScale:_zoomScale];
    [_scrollView setContentOffset:CGPointZero];

    [self performSelectorOnMainThread:@selector(recoveryZoomScaleNotAnimated) withObject:nil waitUntilDone:NO];
    [_indicator stopAnimating];
}

- (void)imageViewLoadImageFailed:(id)imageView error:(NSError *)error
{
    CGSize size = [[imageView image] size];
    size.height = size.height;
    size.width = size.width;
    CGRect rect = [_imageView frame];
    rect.size = size;
    [_imageView setFrame:rect];

    _zoomScale = CGRectGetWidth([_scrollView bounds]) / CGRectGetWidth([_imageView bounds]);
    [_scrollView setContentSize:size];
    [_scrollView setMinimumZoomScale:_zoomScale];
    [_scrollView setContentOffset:CGPointZero];

    [self performSelectorOnMainThread:@selector(recoveryZoomScaleNotAnimated) withObject:nil waitUntilDone:NO];
    [_indicator stopAnimating];
}

@end



#pragma mark -
#pragma mark - ZoomScrollView

@implementation ZoomScrollView

#pragma mark -
#pragma mark - Life Cycle

- (void)dealloc
{
    self.zoomView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_zoomView) {
        CGSize boundsSize = [self bounds].size;
        CGRect frameToCenter = [_zoomView frame];
        // center horizontally
        if (frameToCenter.size.width < boundsSize.width) {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
        } else {
            frameToCenter.origin.x = 0;
        }
        // center vertically
        if (frameToCenter.size.height < boundsSize.height) {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
        } else {
            frameToCenter.origin.y = 0;
        }
        [_zoomView setFrame:frameToCenter];
    }
}

#pragma mark -
#pragma mark - Set Get

- (void)setZoomView:(UIView *)zoomView
{
    if (_zoomView == zoomView) {
        return;
    }
    if (_zoomView) {
        [_zoomView removeFromSuperview];
    }
    _zoomView = zoomView;
    [self addSubview:_zoomView];
}

- (UIView *)zoomView
{
    return _zoomView;
}

@end