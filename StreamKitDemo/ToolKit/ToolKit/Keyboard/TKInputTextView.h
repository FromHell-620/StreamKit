//
//  TKInputTextView.h
//  ToolKit
//
//  Created by chunhui on 16/4/21.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "HPGrowingTextView.h"

@protocol TKInputTextViewDelegate <NSObject>

@required
-(void)pasteContent:(NSString *)content;

@end

@interface TKInputTextView : HPGrowingTextView

@property(nonatomic , weak) id<TKInputTextViewDelegate> pasteDelegate;

-(NSString *)plainText;

-(NSAttributedString *)toEmojiString:(NSString *)source;

@end
