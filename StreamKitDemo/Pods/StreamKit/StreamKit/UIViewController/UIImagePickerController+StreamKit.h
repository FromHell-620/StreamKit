//
//  UIImagePickerController+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (StreamKit)

/**
 Creates a new imagePickerController by the given sourceType.
 @code
 UIImagePickerController* imagePickerController = UIImagePickerController.sk_initWithSourceType(sourceType);
 @endcode
 */
+ (UIImagePickerController* (^)(UIImagePickerControllerSourceType sourceType))sk_initWithSourceType;

/**
 Set delegate.
 */
- (UIImagePickerController* (^)(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate> delegate))sk_delegate;

/**
 Set souceType.
 */
- (UIImagePickerController* (^)(UIImagePickerControllerSourceType souceType))sk_sourceType;

/**
 Set mediaTypes.
 */
- (UIImagePickerController* (^)(NSArray<NSString*> *mediaTypes))sk_mediaTypes;

/**
 Set allowsEditing.
 */
- (UIImagePickerController* (^)(BOOL allowsEditing))sk_allowsEditing;

/**
 Set videoMaximumDuration.
 */
- (UIImagePickerController* (^)(NSTimeInterval videoMaximumDuration))sk_videoMaximumDuration;

/**
 Set videoQuality.
 */
- (UIImagePickerController* (^)(UIImagePickerControllerQualityType videoQuality))sk_videoQuality;

/**
 Set showsCameraControls.
 */
- (UIImagePickerController* (^)(BOOL showsCameraControls))sk_showsCameraControls;

/**
 Set cameraOverlayView.
 */
- (UIImagePickerController* (^)(__kindof UIView* cameraOverlayView))sk_cameraOverlayView;

/**
 Set cameraViewTransform.
 */
- (UIImagePickerController* (^)(CGAffineTransform cameraViewTransform))sk_cameraViewTransform;

/**
 takePicture.
 */
- (UIImagePickerController* (^)())sk_takePicture;

/**
 startVideoCapture.
 */
- (UIImagePickerController* (^)())sk_startVideoCapture;

/**
 stopVideoCapture.
 */
- (UIImagePickerController* (^)())sk_stopVideoCapture;

/**
 Set cameraCaptureMode.
 */
- (UIImagePickerController* (^)(UIImagePickerControllerCameraCaptureMode cameraCaptureMode))sk_cameraCaptureMode;

/**
 Set cameraDevice.
 */
- (UIImagePickerController* (^)(UIImagePickerControllerCameraDevice cameraDevice))sk_cameraDevice;

/**
 Set cameraFlashMode.
 */
- (UIImagePickerController* (^)(UIImagePickerControllerCameraFlashMode cameraFlashMode))sk_cameraFlashMode;

@end

@interface UIImagePickerController (StreamDelegate)

/**
 Instead of the 'imagePickerController:didFinishPickingMediaWithInfo:'.
 @code
 self.sk_imagePickerControllerDidFinishPickingMediaWithInfo(^(UIImagePickerController* picker,NSDictionary* info){
    your code;
 });
 @endcode
 */
- (UIImagePickerController* (^)(void(^block)(UIImagePickerController* picker,NSDictionary* info)))sk_imagePickerControllerDidFinishPickingMediaWithInfo;

/**
 Instead of the 'imagePickerControllerDidCancel:'.
 @code
 self.sk_imagePickerControllerDidCancel(^(UIImagePickerController* picker){
    your code;
 });
 @endcode
 */
- (UIImagePickerController* (^)(void(^block)(UIImagePickerController* picker)))sk_imagePickerControllerDidCancel;

@end
