//
//  NSInvocation+SKValues.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/30.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSInvocation+SKValues.h"
#import "SKValueNil.h"

@implementation NSInvocation (SKValues)

- (NSArray *)sk_values {
    NSInteger argmentCount = self.methodSignature.numberOfArguments;
    NSMutableArray *values = NSMutableArray.new;
    for (NSInteger i = 2; i < argmentCount; i ++) {
        [values addObject:[self sk_argmentWithIndex:i] ? : SKValueNil.ValueNil];
    }
    return values.copy;
}

- (id)sk_argmentWithIndex:(NSInteger)index {
#define WRAP_AND_RETURN(type) \
do { \
type val = 0; \
[self getArgument:&val atIndex:(NSInteger)index]; \
return @(val); \
} while (0)
    
    const char *argType = [self.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [self getArgument:&returnObj atIndex:(NSInteger)index];
        return returnObj;
    } else if (strcmp(argType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(argType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [self getArgument:&block atIndex:(NSInteger)index];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self getArgument:valueBytes atIndex:(NSInteger)index];
        
        return [NSValue valueWithBytes:valueBytes objCType:argType];
    }
    
    return nil;
    
#undef WRAP_AND_RETURN
}

- (void)sk_setArgmentWithValue:(id)value atIndex:(NSInteger)index {
#define WRAP_AND_SET(obj,type) \
do { \
type val = [obj type##Value]; \
[self setArgument:&val atIndex:index]; \
} while (0)
    
    const char *argType = [self.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        [self setArgument:&value atIndex:index];
    } else if (strcmp(argType, @encode(char)) == 0) {
        WRAP_AND_SET(value, char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WRAP_AND_SET(value, int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WRAP_AND_SET(value, short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WRAP_AND_SET(value, long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        long long val = [value longLongValue];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        unsigned char val = [value unsignedCharValue];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        unsigned int val = [value unsignedIntValue];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        unsigned short val = [value unsignedShortValue];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        unsigned long val = [value unsignedLongValue];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        unsigned long long val = [value unsignedLongLongValue];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(float)) == 0) {
        WRAP_AND_SET(value,float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WRAP_AND_SET(value,double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WRAP_AND_SET(value,bool);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        const char *val = [value isKindOfClass:NSNumber.class] ? [[value stringValue] UTF8String] : [value UTF8String];
        [self setArgument:&val atIndex:index];
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        id block = [value copy];
        [self setArgument:&block atIndex:index];
    } else {
        NSCAssert(NO, @"NO SUPPORT TYPE");
    }
    
#undef WRAP_AND_SET
}

@end
