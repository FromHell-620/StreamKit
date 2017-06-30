//
//  FSPhotoBrowserHelper.h
//  news
//
//  Created by chunhui on 15/4/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPhotoBrowser.h"

@interface FSPhotoBrowserHelper : NSObject

@property(nonatomic , strong) NSArray *images;
@property(nonatomic , strong) NSArray *snapshotAndUrlImages;
@property(nonatomic , assign) int currentIndex;
@property(nonatomic , weak) UIImageView *liftImageView;

-(void)show;

@end

@interface SnapShotAndImage : NSObject

@property(nonatomic ,strong) UIImage *snapshot;
@property(nonatomic ,strong) NSString *url;

@end