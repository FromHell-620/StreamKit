//
//  TKShareResult.h
//  ToolKit
//
//  Created by wxc on 16/8/15.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  TKShareResponse
 */
@interface TKShareResult : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *resultDescription;

@end
