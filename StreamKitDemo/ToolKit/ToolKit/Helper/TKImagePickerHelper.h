//
//  TKImagePickerHelper.h
//  Toolkit
//
//  Created by chunhui on 15/12/11.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface TKImagePickerHelper : NSObject

@property(nonatomic , copy)   void (^chooseImageBlock)(UIImage *image ,  NSDictionary<NSString *,id> * editingInfo);
@property(nonatomic , copy)   void (^cancelBlock)();

/**
 *  图片选择 不能编辑图片
 *
 *  @param presentController present view controller
 *  @param sourceType        图片source type 相册 或者照相机
 */
-(void)showPickerWithPresentController:(UIViewController *)presentController sourceType:(UIImagePickerControllerSourceType)sourceType;

/**
 *  图片选择
 *
 *  @param presentController present view controller
 *  @param sourceType        图片source type 相册 或者照相机
 *  @param allowEdit         是否允许编辑
 */
-(void)showPickerWithPresentController:(UIViewController *)presentController sourceType:(UIImagePickerControllerSourceType)sourceType allowEdit:(BOOL)allowEdit;

@end
