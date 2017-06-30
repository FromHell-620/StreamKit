//
//  FSPhotoBrowser.h
//  FSPhotoBrowser
//
//  Created by Fengshan.yang on 14-2-15.
//  Copyright (c) 2014年 Fanyi Network techonology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FSPhotoBrowser;

typedef NS_ENUM(NSInteger, PhotoBrowerScrollButtonType) {
    PhotoBrowerScrollButtonTypeGoBack  = 0,    //  goback buton type
    PhotoBrowerScrollButtonTypeLike       ,    //  like button type
};

typedef NS_ENUM(NSInteger, PhotoBrowerScrollRequestDataType) {
    PhotoBrowerScrollRequestDataTypeForNull        = 0,
    PhotoBrowerScrollRequestDataTypeForImageURL       ,    //  request image url
    PhotoBrowerScrollRequestDataTypeForTitle          ,    //  request title
    PhotoBrowerScrollRequestDataTypeForDescription    ,    //  request description
};

@protocol PhotoBrowerScrollImageViewDataSource <NSObject>

@required
/**
 *  @description
 *      Tells the data source to return the data with a PhotoBrowerScrollRequestDataType type.
 *  @params
 *      view    The FSPhotoBrowser object requesting this information.
 *  @params
 *      type    PhotoBrowerScrollRequestDataType.
 *  @params
 *      index   Photo index.
 *  @return
 *      return  Rquest data.
 */
- (NSString *)photoBrowser:(FSPhotoBrowser *)browser
                  requestDataWithType:(PhotoBrowerScrollRequestDataType)type
                              atIndex:(NSInteger)index;
- (UIImage *)snapshotImagePhotoBrowser:(FSPhotoBrowser *)browser
           requestDataWithType:(PhotoBrowerScrollRequestDataType)type
                       atIndex:(NSInteger)index;

- (UIImage *)imagePhotoBrowser:(FSPhotoBrowser *)browser
       requestDataWithType:(PhotoBrowerScrollRequestDataType)type
                   atIndex:(NSInteger)index;

@end


@protocol PhotoBrowerScrollImageViewDelegate <NSObject>

@optional
/**
 *  @description
 *      Tells the delegate that the FSPhotoBrowser did scroll index.
 *  @params
 *      view    The FSPhotoBrowser object requesting this information.
 *  @params
 *      index   did scroll index.
 */
- (void)photoBrowser:(FSPhotoBrowser *)view currentPhotoIndex:(NSInteger)index;

/**
 *  @description
 *      Tells the delegate that the FSPhotoBrowser buton did click with PhotoBrowerScrollButtonType.
 *  @params
 *      view    The FSPhotoBrowser object requesting this information.
 *  @params
 *      type    PhotoBrowerScrollButtonType.
 */
- (void)photoBrowser:(FSPhotoBrowser *)view didClickButtonWithType:(PhotoBrowerScrollButtonType)type atIndex:(NSInteger)index;

@end


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoBrowerScrollOrientation) {
    PhotoBrowerScrollOrientationLeft   = 0,        //  Sliding to the left.
    PhotoBrowerScrollOrientationRight     ,        //  Sliding to the right.
};

@interface FSPhotoBrowser : UIView
{
@private
    UIScrollView *_infiniteScroll;  //  the background scroll view.
    NSMutableArray *_zoomImageViews;    //  an array which contains four FSZoomImageView instances.
    NSInteger _numberOfImages;
    NSInteger _currentImageIndex;
    struct {
        unsigned int scrollviewExpand:1;
        unsigned int orientation:2;
        unsigned int didMoveToWindow:1;
    } _photoFlags;
}

@property (nonatomic, weak) id<PhotoBrowerScrollImageViewDataSource> dataSource;
@property (nonatomic, weak) id<PhotoBrowerScrollImageViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger numberOfImages; //  total images
@property (nonatomic, readonly) NSInteger currentImageIndex;  //  current image
@property (nonatomic, copy) dispatch_block_t tapBlock;   //  did tap

@property (nonatomic, weak) UIImageView *liftImageView;

//  TODO:....
- (void)setNumberOfImages:(NSInteger)numberOfImages andCurrentImageIndex:(NSInteger)currentIndex;

//  TODO:....
- (void)willRemovePhotoBrowser;

@end
