# StreamKit
============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/godL/StreamKit/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/StreamKit.svg?style=flat)](http://cocoapods.org/?q=StreamKit)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/StreamKit.svg?style=flat)](http://cocoapods.org/?q=StreamKit)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

A chain-programming framework for iOS.


Installation
==============

### CocoaPods

1. Add `pod 'StreamKit'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<StreamKit/StreamKit.h>\.


Usage
==============

### Basic 
    //(Create a UILabel)
    UILabel* label = [UILabel new];//UILabel.new
    label.sk_frame(CGRectZero)
    .sk_fontSize(15)
    .sk_textAlignment(NSTextAlignmentCenter)
    .sk_textColor([UIColor redColor])
    .sk_text(@"a label")
    .sk_addSimpleClickAction(^{
        //click action
    });
    [self.view addSubview:label];


    //event block(create a button)
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.sk_frame(CGRectMake(100, 100, 100, 100))
    .sk_setTitleNormal(@"a button")
    .sk_setTitleColorNormal([UIColor redColor])
    .sk_setFontSize(15)
    .sk_addEventBlock(UIControlEventTouchDown,^(UIButton* button){

    })
    .sk_addEventBlock(UIControlEventTouchUpInside,^(UIButton* button){

    })
    .sk_addEventBlock(UIControlEventTouchUpOutside,^(UIButton* button){

    });
    [self.view addSubview:button];



    //delegate block(create a textField)
    UITextField* textField = UITextField.sk_init(CGRectZero)
    .sk_textColor([UIColor blackColor])
    .sk_fontSize(15)
    .sk_placeholder(@"begin")
    .sk_addEventBlock(UIControlEventEditingChanged,^(UITextField* textField){

    })
    .sk_textFieldShouldReturn(^BOOL(UITextField* textField){
        return YES;
    })
    .sk_textFieldShouldBeginEditing(^BOOL(UITextField* textField){
        return YES;
    })
    .sk_textFieldShouldChangeCharactersInRange(^BOOL(UITextField* textField,NSRange range,NSString* string){
        return YES;
    });
    [self.view addSubview:textField];


    //KVO
    label.sk_addObserverWithKeyPath(@"text",^(NSDictionary* change){

    });


    //NSNotification
    NSNotificationCenter* defaultNotification = [NSNotificationCenter defaultCenter];
    defaultNotification.sk_addNotification(UITextFieldTextDidChangeNotification,^(NSNotification* noti){

    })
    .sk_addNotification(UITextFieldTextDidEndEditingNotification,^(NSNotification* noti){

    });

License
==============
StreamKit is provided under the MIT license. See LICENSE file for details.
