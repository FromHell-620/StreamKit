<p align="center">
<img src="https://raw.githubusercontent.com/meituan/EasySequence/master/images/banner.png" alt="EasySequence">  
</p>

[![CI Status](http://img.shields.io/travis/meituan/EasySequence.svg?style=flat)](https://travis-ci.org/meituan/EasySequence)
[![Version](https://img.shields.io/cocoapods/v/EasySequence.svg?style=flat)](http://cocoapods.org/pods/EasySequence)
[![License](https://img.shields.io/cocoapods/l/EasySequence.svg?style=flat)](http://cocoapods.org/pods/EasySequence)
[![Platform](https://img.shields.io/cocoapods/p/EasySequence.svg?style=flat)](http://cocoapods.org/pods/EasySequence)

EasySequence is a powerful fundamental library to process sequcence type, such as array, set, dictionary. All type object which conforms to NSFastEnumeration protocol can be initialzed to an EZSequence instance, then you can operation with them. Finally, you can transfer them back to the original type.

## Requirements

iOS 8.0 or later.

## Installation

EasySequence is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasySequence'
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Features

### Creating

- can be initialized from any object which conforms to `NSFastEnumeration` protocol.

### Enumerating

- enumerate using `forEach:`
- enumerate using `forEachWithIndex:`
- enumerate using fast enumeration
- enumerate using NSEnumerator

### Operations

- map
- flatten map
- filter
- select
- reject
- take
- skip
- any
- zip
- reduce
- group by
- first object
- first object where
- first index where

### Transfer

- An object which conforms to `EZSTransfer` protocol can get an instance which transfer from `EZSequence`.

### Thread-Safety Type

We provides thread-safety types as below:

- EZSArray
- EZSWeakArray
- EZSOrderedSet
- EZSWeakOrderedSet
- EZSQueue

### Weak Container

`EZSWeakArray` and `EZSWeakOrderedSet` form weak reference to their's items.

## Example

### Create a sequence

A *sequence*,  represented by the `EZSequence` type, is a particular order in which ralated objects, or objects follow each other. For example, a `NSArray` or a `NSSet` is sequence ather than `EZSequence`.

An `EZSequence` can be initialized from any object which conforms to `NSFastEnumeration` protocol.

```objective-c

NSArray *array = @[@1, @2, @3];
EZSequence *sequence = [[EZSequence alloc] initWithOriginSequence:array];
```

### Enumerating

- Enumerate using fast enumeration

```objective-c
EZSequence *sequence = [[EZSequence alloc] initWithOriginSequence:@[@1, @2, @3]];
NSMutableArray *receive = [NSMutableArray array];
for (id item in sequence) {
    [receive addObject:item];
}
```
- Enumerate using NSEnumerator

```objective-c
EZSequence<NSNumber *> *sequence = [[EZSequence alloc] initWithOriginSequence:@[@1, @2, @3]];
NSMutableArray<NSNumber *> *receive = [NSMutableArray array];

NSEnumerator<NSNumber *> *enumerator = [sequence objectEnumerator];
for (id item in enumerator) {
    [receive addObject:item];
}
```

- Enumerate using block-based enumeration

```objective-c
EZSequence<NSNumber *> *sequence = [[EZSequence alloc] initWithOriginSequence:@[@1, @2, @3]];
NSMutableArray *receive = [NSMutableArray array];
[sequence forEach:^(NSNumber *item) {
    [receive addObject:item];
}];

[sequence forEachWithIndex:^(NSNumber * _Nonnull item, NSUInteger index) {
    [receive addObject:item];
}];

[sequence forEachWithIndexAndStop:^(NSNumber * _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
    if (index == 2) {
        *stop = YES;
    }
    [receive addObject:item];
}];
```

### Operations

- map

```objective-c
EZSequence<NSString *> *sequence = EZS_Sequence(@[@"111", @"222", @"333"]);
EZSequence<NSNumber *> *mappedSequence = [sequence map:^id _Nonnull(NSString * _Nonnull value) {
    return @(value.integerValue);
}];
// mappedSequence => @111, @222, @333
```

- select

```objective-c
EZSequence<NSNumber *> *sequence = [@[@1, @2, @3, @4, @5, @6] EZS_asSequence];
EZSequence<NSNumber *> *oddNumbers = [sequence select:^BOOL(NSNumber * _Nonnull value) {
    return value.integerValue % 2 == 1;
}];
// oddNumbers => @1, @3, @5
```

- filter

```objective-c
EZSequence *seq = EZS_Sequence(@[@"1", @"2", @"3", @"4", @"5"]);
EZSequence *filteredSeq = [seq filter:EZS_not(EZS_isEqual(@"4"))];
// filteredSeq = > @"1", @"2", @"3", @"5"
```

- zip

```objective-c
NSArray *a = @[@1, @2, @3];
NSArray *b = @[@"a", @"b"];
EZSequence<EZSequence *> *zippedSeq = [EZSequence zip:@[a, b]];
// zippedSeq => @[@1, @"a"], @[@2, @"b"]
```

For more examples and help, see also our unit test and API comments.

### Transfer Protocol

An object which conforms to `EZSTransfer` protocol can get an instance which transfer from `EZSequence`.

```objective-c

EZSequence *sequence = [[EZSequence alloc] initWithOriginSequence:@[@1, @2, @3, @2]];

// transfer to a `NSArray`
NSArray *array = [sequence as:NSArray.class];
// array => @1, @2, @3, @2

// transfer to a `NSSet`
NSSet *set = [sequence as:NSSet.class];
// set => @1, @2, @3

// transfer to a `NSOrderedSet`
NSOrderedSet *orderedSet = [sequence as:NSOrderedSet.class];
// orderedSet => @1, @2, @3
```

## Author

William Zang, [chengwei.zang.1985@gmail.com](mailto:chengwei.zang.1985@gmail.com)  
姜沂, [nero_jy@qq.com](mailto:nero_jy@qq.com)  
Qin Hong, [qinhong@face2d.com](mailto:qinhong@face2d.com)  
SketchK, [zhangsiqi1988@gmail.com](mailto:zhangsiqi1988@gmail.com)

## License

EasySequence is available under the MIT license. See the LICENSE file for more info.
