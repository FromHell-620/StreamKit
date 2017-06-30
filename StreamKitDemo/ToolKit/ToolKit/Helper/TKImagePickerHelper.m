//
//  TKImagePickerHelper.m
//  CaiLianShe
//
//  Created by chunhui on 15/12/11.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKImagePickerHelper.h"
#import "ImageHelper.h"

@import AVFoundation;


@interface TKImagePickerHelper()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic , strong) UIViewController *presentController;
@property(nonatomic , assign) BOOL allowEdit;

@end

@implementation TKImagePickerHelper

-(void)showPickerWithPresentController:(UIViewController *)presentController sourceType:(UIImagePickerControllerSourceType)sourceType
{
    [self showPickerWithPresentController:presentController sourceType:sourceType allowEdit:NO];
}

-(void)showPickerWithPresentController:(UIViewController *)presentController sourceType:(UIImagePickerControllerSourceType)sourceType allowEdit:(BOOL)allowEdit
{
    
    self.presentController = presentController;
    self.allowEdit = allowEdit;
    
    [self showImagePicker:sourceType allowEdit:allowEdit];
    
}

-(void)showImagePicker:(UIImagePickerControllerSourceType)sourcetype allowEdit:(BOOL)allowEdit
{
    //上传图片
    
    switch (sourcetype) {
        case UIImagePickerControllerSourceTypeCamera://Take picture
        {
#if TARGET_IPHONE_SIMULATOR
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                NSLog(@"模拟器无法打开相机");
                return;
            }
#endif
            
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请为财联社开放相机权限，手机设置－隐私－相机－财联社（打开）" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            break;
        }
        case UIImagePickerControllerSourceTypePhotoLibrary://From album
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum:

            break;
            
        default:
            
            return;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setAllowsEditing:allowEdit];
    picker.sourceType = sourcetype;
    
    [self.presentController presentViewController: picker animated: YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (_chooseImageBlock ) {
            UIImage *image = nil;
            if (_allowEdit) {
                image = info[UIImagePickerControllerEditedImage];
            }
            if (image == nil) {
                image = info[UIImagePickerControllerOriginalImage];
            }
            image = [ImageHelper normImageOrientation:image];
            _chooseImageBlock(image , info);
        }
    }];
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (_chooseImageBlock ) {
            UIImage *finalImage = nil;
            if (_allowEdit) {
                finalImage = editingInfo[UIImagePickerControllerEditedImage];
            }
            if (finalImage == nil) {
                finalImage = image;
            }
            UIImage * normalizeImage = [ImageHelper normImageOrientation:image];
            _chooseImageBlock(normalizeImage , editingInfo);
        }
    }];
}
 */

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_cancelBlock) {
            _cancelBlock();
        }
    }];
}


@end
