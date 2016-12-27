//
//  UITableView+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/26.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UITableView+StreamKit.h"

@implementation UITableView (StreamKit)

+ (UITableView* (^)(CGRect frame))sk_initWithFrame
{
    return ^ UITableView* (CGRect frame) {
        return [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    };
}

+ (UITableView* (^)(CGRect frame,UITableViewStyle style))sk_initWithFrameAndStyle
{
    return ^ UITableView* (CGRect frame,UITableViewStyle style) {
        return [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    };
}

- (UITableView* (^)(id<UITableViewDataSource> dataSource))sk_dataSource
{
    return ^ UITableView* (id<UITableViewDataSource> dataSource) {
        return ({self.dataSource = dataSource;self;});
    };
}

- (UITableView* (^)(id<UITableViewDelegate> delegate))sk_delegate
{
    return ^ UITableView* (id<UITableViewDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UITableView* (^)(id<UITableViewDataSourcePrefetching> prefetchDataSource))sk_prefetchDataSource
{
    return ^ UITableView* (id<UITableViewDataSourcePrefetching> prefetchDataSource) {
        return ({self.prefetchDataSource = prefetchDataSource;self;});
    };
}

- (UITableView* (^)(CGFloat rowHeight))sk_rowHeight
{
    return ^ UITableView* (CGFloat rowHeight) {
        return ({self.rowHeight = rowHeight;self;});
    };
}

- (UITableView* (^)(CGFloat sectionHeaderHeight))sk_sectionHeaderHeight
{
    return ^ UITableView* (CGFloat sectionHeaderHeight) {
        return ({self.sectionHeaderHeight = sectionHeaderHeight;self;});
    };
}

- (UITableView* (^)(CGFloat sectionFooterHeight))sk_sectionFooterHeight
{
    return ^ UITableView* (CGFloat sectionFootHeight) {
        return ({self.sectionFooterHeight = sectionFootHeight;self;});
    };
}

- (UITableView* (^)(CGFloat estimatedRowHeight))sk_estimatedRowHeight
{
    return ^ UITableView* (CGFloat estimatedRowHeight) {
        return ({self.estimatedRowHeight = estimatedRowHeight;self;});
    };
}

- (UITableView* (^)(CGFloat estimatedSectionHeaderHeight))sk_estimatedSectionHeaderHeight
{
    return ^ UITableView* (CGFloat estimatedSectionHeaderHeight) {
        return ({self.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight;self;});
    };
}

- (UITableView* (^)(CGFloat estimatedSectionFooterHeight))sk_estimatedSectionFooterHeight
{
    return ^ UITableView* (CGFloat estimatedSectionFooterHeight) {
        return ({self.estimatedSectionFooterHeight = estimatedSectionFooterHeight;self;});
    };
}

- (UITableView* (^)(UIEdgeInsets separatorInset))sk_separatorInset
{
    return ^ UITableView* (UIEdgeInsets separatorInset) {
        return ({self.separatorInset = separatorInset;self;});
    };
}

- (UITableView* (^)(UIView* backgroundView))sk_backgroundView
{
    return ^ UITableView* (UIView* backgroundView) {
        return ({self.backgroundView = backgroundView;self;});
    };
}

- (UITableView* (^)(UITableViewCellSeparatorStyle separatorStyle))sk_separatorStyle
{
    return ^ UITableView* (UITableViewCellSeparatorStyle separatorStyle) {
        return ({self.separatorStyle = separatorStyle;self;});
    };
}

- (UITableView* (^)(UIView* tableHeaderView))sk_tableHeaderView
{
    return ^ UITableView* (UIView* tableHeaderView) {
        return ({self.tableHeaderView = tableHeaderView;self;});
    };
}

- (UITableView* (^)(UIView* tableFooterView))sk_tableFooterView
{
    return ^ UITableView* (UIView* tableFooterView) {
        return ({self.tableFooterView = tableFooterView;self;});
    };
}

- (UITableView* (^)(Class cellClass,NSString* identifier))sk_registerClassForCellReuseIdentifier
{
    return ^ UITableView* (Class cellClass,NSString* identifier) {
        return ({[self registerClass:cellClass forCellReuseIdentifier:identifier];self;});
    };
}

- (UITableView* (^)(UINib* nib,NSString* identifier))sk_registerNibForCellReuseIdentifier
{
    return ^ UITableView* (UINib* nib,NSString* identifier) {
        return ({[self registerNib:nib forCellReuseIdentifier:identifier];self;});
    };
}

- (UITableView* (^)(Class viewClass,NSString* identifier))sk_registerClassForHeaderFooterViewReuseIdentifier
{
    return ^ UITableView* (Class viewClass,NSString* identifier) {
        return ({[self registerClass:viewClass forHeaderFooterViewReuseIdentifier:identifier];self;});
    };
}

- (UITableView* (^)(UINib* nib,NSString* identifier))sk_registerNibForHeaderFooterViewReuseIdentifier
{
    return ^ UITableView* (UINib* nib,NSString* identifier) {
        return ({[self registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];self;});
    };
}

@end

@implementation UITableViewCell (StreamKit)

+ (UITableViewCell* (^)(UITableViewCellStyle cellStyle,NSString* reuseIdentifier))sk_initWithStyleAndReuseIdentifier
{
    return ^ UITableViewCell* (UITableViewCellStyle cellStyle,NSString* reuseIdentifier) {
        return [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    };
}

- (UITableViewCell* (^)(UITableViewCellSelectionStyle selectionStyle))sk_selectionStyle
{
    return ^ UITableViewCell* (UITableViewCellSelectionStyle selectionStyle) {
        return ({self.selectionStyle = selectionStyle;self;});
    };
}

- (UITableViewCell* (^)(UITableViewCellAccessoryType accessoryType))sk_accessoryType
{
    return ^ UITableViewCell* (UITableViewCellAccessoryType accessoryType) {
        return ({self.accessoryType = accessoryType;self;});
    };
}

- (UITableViewCell* (^)(UITableViewCellAccessoryType editingAccessoryType))sk_editingAccessoryType
{
    return ^ UITableViewCell* (UITableViewCellAccessoryType editingAccessoryType) {
        return ({self.editingAccessoryType = editingAccessoryType;self;});
    };
}

@end
