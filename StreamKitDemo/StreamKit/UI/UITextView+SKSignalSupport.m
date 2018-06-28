//
//  UITextView+SKSignalSupport.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/28.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UITextView+SKSignalSupport.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "SKObjectifyMarco.h"

@implementation UITextView (SKSignalSupport)

- (SKSignal *)sk_textSignal {
    @weakify(self)
    return [SKSignal defer:^{
        @strongify(self)
        return [SKSignal return:self];
    }];
}

@end
