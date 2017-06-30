//
//  TKTabControllerIniter.h
//  ToolKit
//
//  Created by chunhui on 15/6/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TKTabControllerIniter : NSObject

+(UITabBarController *)tabbarControllerWithItems:(NSArray *)items;
+(NSArray<UIViewController *> *)viewControllersWithItems:(NSArray *)items;

@end

@interface TKTabControllerItem : NSObject
/**
 *  controller的名称
 */
@property(nonatomic , copy) NSString *controllerName;
/**
 *  tab bar 的名称
 */
@property(nonatomic , copy) NSString *title;
/**
 *  tab bar 的title的颜色
 */
@property(nonatomic , strong) UIColor *titleNormalColor;
/**
 *  tab bar 的title的选中颜色
 */
@property(nonatomic , strong) UIColor *titleSelectedColor;
/**
 *  tab bar image  与 tabImageName二者选一个
 */
@property(nonatomic , strong) UIImage *tabImage;
@property(nonatomic , copy) NSString *tabImageName;
/**
 *  选中的图片
 */
@property(nonatomic , strong) UIImage *tabSelectedImage;
@property(nonatomic , copy) NSString *tabSelectedImageName;

/*
 * 是否外加navigation controller
 */
@property(nonatomic , assign) BOOL addNavController;

/*
 * custom navigationcontroller 类名，默认时为空
 */
@property(nonatomic , copy) NSString *navContorllerName;


-(instancetype)initWithControllerName:(NSString *)controllerName title:(NSString *)title tabImageName:(NSString *)tabImageName;
-(instancetype)initWithControllerName:(NSString *)controllerName title:(NSString *)title tabImageName:(NSString *)tabImageName selectedImageName:(NSString *)selectedImageName;

@end
