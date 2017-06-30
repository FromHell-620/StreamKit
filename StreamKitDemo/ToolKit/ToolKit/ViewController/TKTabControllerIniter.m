//
//  TKTabControllerIniter.m
//  ToolKit
//
//  Created by chunhui on 15/6/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKTabControllerIniter.h"
@import UIKit;

@implementation TKTabControllerIniter

+(UITabBarController *)tabbarControllerWithItems:(NSArray *)items
{

    UITabBarController *controller = [[UITabBarController alloc]initWithNibName:nil bundle:nil];
    
    NSMutableArray *subControllers = [[NSMutableArray alloc]init];
    for (TKTabControllerItem *item in items) {
        Class clazz = NSClassFromString(item.controllerName);
        UIViewController *subContorller = [[clazz alloc]initWithNibName:item.controllerName bundle:nil];
        UIImage *tabImage = item.tabImage;
        if (tabImage == nil && item.tabImageName.length > 0) {
            tabImage = [UIImage imageNamed:item.tabImageName];
        }
        UIImage *tabSelectedImage = item.tabSelectedImage;
        if (tabSelectedImage == nil && item.tabSelectedImageName.length > 0) {
            tabSelectedImage = [UIImage imageNamed:item.tabSelectedImageName];
        }
        if (tabSelectedImage == nil) {
            tabSelectedImage = tabImage;
        }
        UITabBarItem *tabbarItem = [[UITabBarItem alloc]initWithTitle:item.title image:tabImage selectedImage:tabSelectedImage];
        
//        subContorller.tabBarItem = tabbarItem;
        
        subContorller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:subContorller];
        navController.title = item.title;
        subContorller.title = item.title;
        navController.tabBarItem = tabbarItem;
        [subControllers addObject:navController];
    }
    controller.viewControllers = subControllers;
    
    return controller;
    
}

+ (Class)swiftClassFromString:(NSString *)className {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    
    NSString *classStringName = [NSString stringWithFormat:@"_TtC%d%@%d%@", (int)appName.length, appName, (int)className.length, className];
    return NSClassFromString(classStringName);
}

+(NSArray<UIViewController *> *)viewControllersWithItems:(NSArray *)items
{
    NSMutableArray *subControllers = [[NSMutableArray alloc]init];
    
    for (TKTabControllerItem *item in items) {
        Class clazz = NSClassFromString(item.controllerName);
        if (clazz == nil) {
            //try load swift
            clazz = [self swiftClassFromString:item.controllerName];
        }
        NSAssert(clazz, @"class for name %@ can't be load",item.controllerName);
        UIViewController *subContorller = [[clazz alloc]initWithNibName:nil bundle:nil];
        UIImage *tabImage = item.tabImage;
        if (tabImage == nil) {
            tabImage = [UIImage imageNamed:item.tabImageName];
            tabImage = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        UIImage *tabSelectedImage = item.tabSelectedImage;
        if (tabSelectedImage == nil && item.tabSelectedImageName.length > 0) {
            tabSelectedImage = [UIImage imageNamed:item.tabSelectedImageName];
            tabSelectedImage = [tabSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if (tabSelectedImage == nil) {
            tabSelectedImage = tabImage;
        }
        
        UITabBarItem *tabbarItem = [[UITabBarItem alloc]initWithTitle:item.title image:tabImage selectedImage:tabSelectedImage];
        if (item.titleNormalColor) {
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:item.titleNormalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        }
        if (item.titleSelectedColor) {
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:item.titleSelectedColor,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
        }
        
        [tabbarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
        subContorller.tabBarItem = tabbarItem;        
        
        if (item.addNavController) {

            UINavigationController *navController;
            if (item.navContorllerName) {
                Class navClass = NSClassFromString(item.navContorllerName);
                navController  = [[navClass alloc]initWithRootViewController:subContorller];
            }else{
                navController = [[UINavigationController alloc]initWithRootViewController:subContorller];
            }
            
            subContorller.title = item.title;
            navController.tabBarItem = tabbarItem;            
            [subControllers addObject:navController];
            
            navController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)subContorller;
            navController.interactivePopGestureRecognizer.enabled = true;
                                    
        }else{
            subContorller.title = item.title;
            [subControllers addObject:subContorller];
        }
    }
    
    return subControllers;
}

@end


@implementation TKTabControllerItem


-(instancetype)initWithControllerName:(NSString *)controllerName title:(NSString *)title tabImageName:(NSString *)tabImageName
{
    return [self initWithControllerName:controllerName title:title tabImageName:tabImageName selectedImageName:nil];
}

-(instancetype)initWithControllerName:(NSString *)controllerName title:(NSString *)title tabImageName:(NSString *)tabImageName selectedImageName:(NSString *)selectedImageName
{
    self = [super init];
    if (self) {
        self.controllerName = controllerName;
        self.title = title;
        self.tabImageName = tabImageName;
        self.tabSelectedImageName = selectedImageName;
    }
    return self;
}


@end