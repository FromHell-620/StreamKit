//
//  UIImagePickerController+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (StreamKit)
+ (UIImagePickerController* (^)(UIImagePickerControllerSourceType sourceType))sk_initWithSourceType;

- (UIImagePickerController* (^)(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate> delegate))sk_delegate;

- (UIImagePickerController* (^)(UIImagePickerControllerSourceType souceType))sk_sourceType;

- (UIImagePickerController* (^)(NSArray<NSString*> *mediaTypes))sk_mediaTypes;

- (UIImagePickerController* (^)(BOOL allowsEditing))sk_allowsEditing;

- (UIImagePickerController* (^)(NSTimeInterval videoMaximumDuration))sk_videoMaximumDuration;

- (UIImagePickerController* (^)(UIImagePickerControllerQualityType videoQuality))sk_videoQuality;

- (UIImagePickerController* (^)(BOOL showsCameraControls))sk_showsCameraControls;

- (UIImagePickerController* (^)(__kindof UIView* cameraOverlayView))sk_cameraOverlayView;

- (UIImagePickerController* (^)(CGAffineTransform cameraViewTransform))sk_cameraViewTransform;

- (UIImagePickerController* (^)())sk_takePicture;

- (UIImagePickerController* (^)())sk_startVideoCapture;

- (UIImagePickerController* (^)())sk_stopVideoCapture;

- (UIImagePickerController* (^)(UIImagePickerControllerCameraCaptureMode cameraCaptureMode))sk_cameraCaptureMode;

- (UIImagePickerController* (^)(UIImagePickerControllerCameraDevice cameraDevice))sk_cameraDevice;

- (UIImagePickerController* (^)(UIImagePickerControllerCameraFlashMode cameraFlashMode))sk_cameraFlashMode;

@end

@interface UIImagePickerController (StreamDelegate)

- (UIImagePickerController* (^)(void(^block)(UIImagePickerController* picker,NSDictionary* info)))sk_imagePickerControllerDidFinishPickingMediaWithInfo;

- (UIImagePickerController* (^)(void(^block)(UIImagePickerController* picker)))sk_imagePickerControllerDidCancel;

@end
