//
//  FSPhotoBrowserHelper.m
//  news
//
//  Created by chunhui on 15/4/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "FSPhotoBrowserHelper.h"



@interface FSPhotoBrowserHelper()<PhotoBrowerScrollImageViewDataSource,PhotoBrowerScrollImageViewDelegate>

@end

@implementation FSPhotoBrowserHelper

-(void)show
{
    
    CGRect frame = [[UIScreen mainScreen]bounds];
    
    FSPhotoBrowser *view = [[FSPhotoBrowser alloc] initWithFrame:frame];
    [view setDataSource:self];
    [view setDelegate:self];
    if (_snapshotAndUrlImages) {
        [view setNumberOfImages:[_snapshotAndUrlImages count] andCurrentImageIndex:_currentIndex];
    }else{
        [view setNumberOfImages:[_images count] andCurrentImageIndex:_currentIndex];
    }
    view.liftImageView = self.liftImageView;
    
    __block typeof(FSPhotoBrowser *) __weak browser = view;
    [view setTapBlock:^() {
        [browser willRemovePhotoBrowser];
    }];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
    
}


- (NSString *)photoBrowser:(FSPhotoBrowser *)browser requestDataWithType:(PhotoBrowerScrollRequestDataType)type atIndex:(NSInteger)index
{
    if([_snapshotAndUrlImages count] > index){
        SnapShotAndImage *item = [_snapshotAndUrlImages objectAtIndex:index];
        return item.url;
    }
    return nil;
}

- (UIImage *)snapshotImagePhotoBrowser:(FSPhotoBrowser *)browser
                   requestDataWithType:(PhotoBrowerScrollRequestDataType)type
                               atIndex:(NSInteger)index
{
    if ([_snapshotAndUrlImages count] > index) {
        SnapShotAndImage *item = [_snapshotAndUrlImages objectAtIndex:index];
        return item.snapshot;
    }
    return nil;
}

- (UIImage *)imagePhotoBrowser:(FSPhotoBrowser *)browser requestDataWithType:(PhotoBrowerScrollRequestDataType)type atIndex:(NSInteger)index
{
    if([self.images count] > index){
        UIImage *image = [self.images objectAtIndex:index];
        
        return image;
    }
    return nil;
}

@end

@implementation SnapShotAndImage



@end