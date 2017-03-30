//
//  StreamObserver.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/29.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "StreamObserver.h"
#import "NSObject+StreamKit.h"

@implementation StreamObserver

- (instancetype)initWithObject:(id)object nilValue:(id)nilValue;
{
    self = [super init];
    if (self) {
        _object = object;
        _nilValue = nilValue;
#ifdef DEBUG
        _name = @"SK_KVC";
#endif
    }
    return self;
}

- (instancetype)initWithObject:(id)object keyPath:(id)keyPath nilValue:(id)nilValue
{
    self = [super init];
    if (self) {
        _object = object;
        _keyPath = keyPath;
        _nilValue = nilValue;
#ifdef DEBUG
        _name = @"SK_KVO";
#endif
    }
    return self;
}

- (void)setObject:(StreamObserver*)object forKeyedSubscript:(NSString *)keyPath
{
    object.object.sk_addObserverWithKeyPath(object.keyPath,^(NSDictionary* change){
        id news = [change valueForKey:@"new"];
        if (!object.nilValue) {
            [_object setValue:news?news:_nilValue forKey:keyPath];
        }else
            [_object setValue:[object.nilValue isEqual:news]?_nilValue:news forKey:keyPath];
    });
}

@end
