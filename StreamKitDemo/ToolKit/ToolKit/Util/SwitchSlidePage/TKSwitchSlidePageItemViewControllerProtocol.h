//
//  TKSwitchSlidePageItemViewControllerProtocol.h
//  ToolKit
//
//  Created by chunhui on 16/4/1.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#ifndef TKSwitchSlidePageItemViewControllerProtocol_h
#define TKSwitchSlidePageItemViewControllerProtocol_h

@protocol TKSwitchSlidePageItemViewControllerProtocol <NSObject>

@required

-(void)pageWillPurge;

-(void)pageWillReuse;

-(void)pageWillShow;

-(BOOL)reuseable;

@end

#endif /* TKSwitchSlidePageItemViewControllerProtocol_h */
