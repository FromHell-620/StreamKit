//
//  TKKeyboardItemCollectionViewLayout.m
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKKeyboardItemCollectionViewLayout.h"

@interface TKKeyboardItemCollectionViewLayout ()

@property (nonatomic,readonly) NSInteger     numberOfItems;
@property (nonatomic,readonly) CGSize        pageSize;

@property (nonatomic,readonly) NSInteger     numberOfItemsPerPage;
@property (nonatomic,readonly) NSInteger     numberOfRowsPerPage;
@property (nonatomic,readonly) NSInteger     numberOfItemsPerRow;
@property (nonatomic,readonly) CGSize        avaliableSizePerPage;

@end


@implementation TKKeyboardItemCollectionViewLayout

-(NSInteger)numberOfItems {
    //We only allow 1 section in this kind of layout.
    NSInteger section = 0;
    NSInteger numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    return numberOfItems;
}

- (CGSize)pageSize {
    return self.collectionView.bounds.size;
}

- (CGSize)avaliableSizePerPage {
    return (CGSize){
        self.pageSize.width - self.pageContentInsets.left - self.pageContentInsets.right,
        self.pageSize.height - self.pageContentInsets.top - self.pageContentInsets.bottom
    };
}

- (NSInteger)numberOfItemsPerRow {
    return floor((self.avaliableSizePerPage.width + self.itemSpacing)/(self.itemSize.width + self.itemSpacing)) ?: 1;
}

- (NSInteger)numberOfRowsPerPage {
    return floor((self.avaliableSizePerPage.height + self.lineSpacing)/(self.itemSize.height + self.lineSpacing)) ?: 1;
}

- (NSInteger)numberOfItemsPerPage {
    return self.numberOfItemsPerRow * self.numberOfRowsPerPage;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size)) {
        return NO;
    }else{
        return YES;
    }
}

- (CGSize)collectionViewContentSize {
    CGFloat width = ceil((float)self.numberOfItems/self.numberOfItemsPerPage) * self.pageSize.width;
    CGFloat height = self.pageSize.height;
    return CGSizeMake(width, height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect frame ;
    if (indexPath.item == self.numberOfItems - 1) {
        //最后一个
        NSInteger pageCount = (indexPath.item + [self numberOfItemsPerPage]-1)/[self numberOfItemsPerPage];
        
        frame = CGRectMake( (pageCount - 1)*self.pageSize.width + self.pageContentInsets.left + (self.numberOfItemsPerRow - 1)*(self.itemSize.width + self.itemSpacing), ([self numberOfRowsPerPage] - 1)*(self.itemSize.width + self.itemSpacing), self.itemSize.width, self.itemSize.height);
        
    }else{
        
        NSInteger index = indexPath.row;
        NSInteger page = floor((float)index/self.numberOfItemsPerPage);
        NSInteger row  = floor((float)(index % self.numberOfItemsPerPage)/self.numberOfItemsPerRow);
        NSInteger n    = index % self.numberOfItemsPerRow;
        frame = (CGRect){
            {page * self.pageSize.width + self.pageContentInsets.left + n*(self.itemSize.width + self.itemSpacing),
                self.pageContentInsets.top + row*(self.itemSize.height + self.lineSpacing)},
            self.itemSize
        };
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.numberOfItems; i++){
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [array addObject:attributes];
        }
    }
    return [array copy];
}



@end
