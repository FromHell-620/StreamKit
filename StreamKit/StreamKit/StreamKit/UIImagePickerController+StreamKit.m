//
//  UIImagePickerController+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIImagePickerController+StreamKit.h"

@implementation UIImagePickerController (StreamKit)

+ (UIImagePickerController* (^)(UIImagePickerControllerSourceType sourceType))sk_initWithSourceType
{
    return ^ UIImagePickerController*(UIImagePickerControllerSourceType sourceType) {
        return ({UIImagePickerController* pc = [self new];pc.sourceType = sourceType;pc;});
    };
}

- (UIImagePickerController* (^)(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate> delegate))sk_delegate
{
    return  ^UIImagePickerController* (id<UIImagePickerControllerDelegate,UINavigationControllerDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UIImagePickerController* (^)(UIImagePickerControllerSourceType souceType))sk_sourceType
{
    return ^ UIImagePickerController* (UIImagePickerControllerSourceType sourceType) {
        return ({self.sourceType = sourceType;self;});
    };
}

- (UIImagePickerController* (^)(NSArray<NSString*> *mediaTypes))sk_mediaTypes
{
    return ^ UIImagePickerController* (NSArray<NSString*>* mediaTypes) {
        return ({self.mediaTypes = mediaTypes;self;});
    };
}

- (UIImagePickerController* (^)(BOOL allowsEditing))sk_allowsEditing
{
    return ^ UIImagePickerController* (BOOL allowsEditing) {
        return ({self.allowsEditing = allowsEditing;self;});
    };
}

- (UIImagePickerController* (^)(NSTimeInterval videoMaximumDuration))sk_videoMaximumDuration
{
    return ^ UIImagePickerController* (NSTimeInterval videoMaximumDuration) {
        return ({self.videoMaximumDuration = videoMaximumDuration;self;});
    };
}

- (UIImagePickerController* (^)(UIImagePickerControllerQualityType videoQuality))sk_videoQuality
{
    return ^ UIImagePickerController* (UIImagePickerControllerQualityType videoQuality) {
        return ({self.videoQuality = videoQuality;self;});
    };
}

- (UIImagePickerController* (^)(BOOL showsCameraControls))sk_showsCameraControls
{
    return ^ UIImagePickerController* (BOOL showsCameraControls) {
        return ({self.showsCameraControls = showsCameraControls;self;});
    };
}

- (UIImagePickerController* (^)(__kindof UIView* cameraOverlayView))sk_cameraOverlayView
{
    return ^ UIImagePickerController* (__kindof UIView* cameraOverlayView) {
        return ({self.cameraOverlayView = cameraOverlayView;self;});
    };
}

- (UIImagePickerController* (^)(CGAffineTransform cameraViewTransform))sk_cameraViewTransform
{
    return ^ UIImagePickerController* (CGAffineTransform cameraViewTransform) {
        return ({self.cameraViewTransform = cameraViewTransform;self;});
    };
}

- (UIImagePickerController* (^)())sk_takePicture
{
    return ^ UIImagePickerController* () {
        return ({[self takePicture];self;});
    };
}

- (UIImagePickerController* (^)())sk_startVideoCapture
{
    return ^ UIImagePickerController* () {
        return ({[self startVideoCapture];self;});
    };
}

- (UIImagePickerController* (^)())sk_stopVideoCapture
{
    return ^ UIImagePickerController* () {
        return ({[self stopVideoCapture];self;});
    };
}

- (UIImagePickerController* (^)(UIImagePickerControllerCameraCaptureMode cameraCaptureMode))sk_cameraCaptureMode
{
    return ^ UIImagePickerController* (UIImagePickerControllerCameraCaptureMode cameraCaptureMode) {
        return ({self.cameraCaptureMode = cameraCaptureMode;self;});
    };
}

- (UIImagePickerController* (^)(UIImagePickerControllerCameraDevice cameraDevice))sk_cameraDevice
{
    return ^ UIImagePickerController* (UIImagePickerControllerCameraDevice cameraDevice) {
        return ({self.cameraDevice = cameraDevice;self;});
    };
}

- (UIImagePickerController* (^)(UIImagePickerControllerCameraFlashMode cameraFlashMode))sk_cameraFlashMode
{
    return ^ UIImagePickerController* (UIImagePickerControllerCameraFlashMode cameraFlashMode) {
        return ({self.cameraFlashMode = cameraFlashMode;self;});
    };
}

@end
