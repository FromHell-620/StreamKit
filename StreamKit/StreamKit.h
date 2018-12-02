//
//  StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#ifndef StreamKit_h
#define StreamKit_h

//Core
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "SKSubject.h"
#import "SKReplaySubject.h"
#import "NSObject+SKObservering.h"
#import "NSObject+SKDeallocating.h"
#import "NSObject+SKSelectorSignal.h"
#import "NSInvocation+SKValues.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKSerialDisposable.h"
#import "SKScopedDisposable.h"
#import "SKValueNil.h"
#import "SKDelegateProxy.h"
#import "NSNotificationCenter+SKSignalSupport.h"
#import "SKSubscribringObserverTrampoline.h"
#import "SKSubscribringSelectorTrampoline.h"
#import "SKMulticastConnection.h"
#import "SKCommand.h"

//UI
#import "UIView+SKSignalSupport.h"
#import "UITextView+SKSignalSupport.h"
#import "UITextField+SKSignalSupport.h"
#import "UIControl+SKSignalSupport.h"
#import "UIButton+SKSignalSupport.h"
#import "UIRefreshControl+SKCommandSupport.h"
#import "UIGestureRecognizer+SKSignalSupport.h"

//Marco
#import "SKMetaMarco.h"
#import "SKKeyPathMarco.h"
#import "SKObjectifyMarco.h"

//Scheduler
#import "SKScheduler.h"

//DelegateProxy
#import "NSObject+SKDelegateProxy.h"
#import "UITextView+SKDelegateProxy.h"
#import "UITextField+SKDelegateProxy.h"
#import "UIScrollView+SKDelegateProxy.h"
#import "UIImagePickerController+SKDelegateProxy.h"
#endif /* StreamKit_h */
