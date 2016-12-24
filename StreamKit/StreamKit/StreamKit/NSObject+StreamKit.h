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

void StreamInitializeDelegateMethod(Class cls,const char* protocol_name,const char* protocol_method_name,const void* AssociatedKey);

void StreamDelegateBindBlock(SEL method,NSObject* delegateObject,id block);

void StreamDataSourceBindBlock(SEL method,NSObject* dataSourceObject,id block);

void StreamSetImplementationToMethod(Class cls,const char* method_name,const char* protocol_method_name,void(*initializeDelegate)(const char* key));

@end

@interface NSObject (StreamKit)



@end
