//
//  ViewController.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "StreamContentController.h"
#import "StreamKit/StreamKit.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

FOUNDATION_STATIC_INLINE char* disposeMethodType(const char* type)
{
    NSCParameterAssert(type);
    char* result = strdup(type);
    char* desk = result;
    char* src = result;
    while (*src) {
        if (isdigit(*src)) {src++;continue;};
        *desk++ = *src++;
    }
    *desk = '\0';
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unsigned int c = 0;
    Protocol* pro = objc_getProtocol("UITextViewDelegate");
    struct objc_method_description* descs =protocol_copyMethodDescriptionList(pro, NO, YES, &c);
    for (int i=0; i<c; i++) {
        struct objc_method_description desc = *(descs+i);
        
        
        NSLog(@"dis === %s",disposeMethodType(desc.types));
    }

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
