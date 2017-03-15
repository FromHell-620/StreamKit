//
//  NSObject+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef IMP (*implementation)(const struct objc_method_description method_desc);

@interface NSObject (StreamProtocol)

void StreamInitializeDelegateMethod(Class cls,Protocol* protocol,const char* protocol_method_name,const void* AssociatedKey);

void StreamDelegateBindBlock(SEL method,NSObject* delegateObject,id block);

void StreamDataSourceBindBlock(SEL method,NSObject* dataSourceObject,id block);

void StreamSetImplementationToDelegateMethod(Class cls,Protocol* protocol,const char* method_name,const char* protocol_method_name);

void StreamHookMehtod(Class hookClass,const char* hookMethodName, void(^aspectBlock)(id target));

@end

@interface NSObject (StreamKit)


/**
 Registers the observer object to receive KVO notifications for the key path relative to the object receiving this message.
 @code
 self.sk_addObserverWithKeyPath(keyPath,^(NSDictionary* change){
    your code;
 });
 
 @return a block which receive a keyPath and a event block.
         the event block will invoke when the value at the specified key path relative to the observed object has changed
 */
- (NSObject*(^)(NSString* keyPath,void(^block)(NSDictionary* change)))sk_addObserverWithKeyPath;


/**
 remove the observer with a keyPath
 @code
 self.sk_removeObserverWithKeyPath(keyPath);
 @endcode
 
 @return a block which receive a keyPath
 */
- (NSObject*(^)(NSString* keyPath))sk_removeOvserverWithKeyPath;


/**
 remove all observers of an object 
 @code
 self.sk_removeAllObserver();
 @endcode

 */
- (NSObject*(^)())sk_removeAllObserver;

@end
