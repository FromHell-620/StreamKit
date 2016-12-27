//
//  UICollectionView+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/27.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UICollectionView+StreamKit.h"

@implementation UICollectionView (StreamKit)

+ (UICollectionView* (^)(CGRect frame,UICollectionViewLayout* layout))sk_initWithFrameAndLayout
{
    return ^ UICollectionView* (CGRect frame,UICollectionViewLayout* layout) {
        return [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    };
}

- (UICollectionView* (^)(UICollectionViewLayout* layout))sk_collectionViewLayout
{
    return ^ UICollectionView* (UICollectionViewLayout* layout) {
        return ({self.collectionViewLayout = layout;self;});
    };
}

- (UICollectionView* (^)(id<UICollectionViewDelegate> delegate))sk_delegate
{
    return ^ UICollectionView* (id<UICollectionViewDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UICollectionView* (^)(id<UICollectionViewDataSource> dataSource))sk_dataSource
{
    return ^ UICollectionView* (id<UICollectionViewDataSource> dataSource) {
        return ({self.dataSource = dataSource;self;});
    };
}

- (UICollectionView* (^)(Class cellClass,NSString* identifier))sk_registerClassForCellWithReuseIdentifier
{
    return ^ UICollectionView* (Class cellClass,NSString* identifier) {
        return ({[self registerClass:cellClass forCellWithReuseIdentifier:identifier];self;});
    };
}

- (UICollectionView* (^)(UINib* nib,NSString* identifier))sk_registerNibForCellWithReuseIdentifier
{
    return ^ UICollectionView* (UINib* nib,NSString* identifier) {
        return ({[self registerNib:nib forCellWithReuseIdentifier:identifier];self;});
    };
}

- (UICollectionView* (^)(Class viewClass,NSString* elementKind,NSString* identifier))sk_registerClassForSupplementaryViewOfKind
{
    return ^ UICollectionView* (Class viewClass,NSString* elementKind,NSString* identifier) {
        return ({[self registerClass:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];self;});
    };
}

- (UICollectionView* (^)(UINib* viewNib,NSString* elementKind,NSString* identifier))sk_registerNibForSupplementaryViewOfKind
{
    return ^ UICollectionView* (UINib* viewNib,NSString* elementKind,NSString* identifier) {
        return ({[self registerNib:viewNib forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];self;});
    };
}

@end

@implementation UICollectionViewFlowLayout (StreamKit)

- (UICollectionViewFlowLayout* (^)(CGFloat minimumLineSpacing))sk_minimumLineSpacing
{
    return ^ UICollectionViewFlowLayout* (CGFloat minimumLineSpacing) {
        return ({self.minimumLineSpacing = minimumLineSpacing;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(CGFloat minimumInteritemSpacing))sk_minimumInteritemSpacing
{
    return ^ UICollectionViewFlowLayout* (CGFloat minimumInteritemSpacing) {
        return ({self.minimumInteritemSpacing = minimumInteritemSpacing;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(CGSize itemSize))sk_itemSize
{
    return ^ UICollectionViewFlowLayout* (CGSize itemSize) {
        return ({self.itemSize = itemSize;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(CGSize estimatedItemSize))sk_estimatedItemSize
{
    return ^ UICollectionViewFlowLayout* (CGSize estimatedItemSize) {
        return ({self.estimatedItemSize = estimatedItemSize;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(UICollectionViewScrollDirection scrollDirection))sk_scrollDirection
{
    return ^ UICollectionViewFlowLayout* (UICollectionViewScrollDirection scrollDirection) {
        return ({self.scrollDirection = scrollDirection;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(CGSize headerReferenceSize))sk_headerReferenceSize
{
    return ^ UICollectionViewFlowLayout* (CGSize headerReferenceSize) {
        return ({self.headerReferenceSize = headerReferenceSize;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(CGSize footerReferenceSize))sk_footerReferenceSize
{
    return ^ UICollectionViewFlowLayout* (CGSize footerReferenceSize) {
        return ({self.footerReferenceSize = footerReferenceSize;self;});
    };
}

- (UICollectionViewFlowLayout* (^)(UIEdgeInsets sectionInset))sk_sectionInset
{
    return ^ UICollectionViewFlowLayout* (UIEdgeInsets sectionInset) {
        return ({self.sectionInset = sectionInset;self;});
    };
}

@end
