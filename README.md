[![Apache
License](https://img.shields.io/github/license/google/functional-objc.svg)](LICENSE)
[![Travis](https://img.shields.io/travis/google/promises.svg)](https://travis-ci.org/google/functional-objc)

# Functional operators for Objective-C

An Objective-C library of functional operators, derived from `Swift.Sequence`,
that help you write more concise and readable code for collection
transformations. Foundation collections supported include: `NSArray`,
`NSDictionary`, `NSOrderedSet`, and `NSSet`.

## Functional Operators

### Filter

Loops over a collection and returns an array that contains elements that meet a
condition.

```objectivec
NSArray<NSNumber *> *filteredArray = [@[ @13, @42, @0 ] fbl_filter:^BOOL(NSNumber *value) {
  return value.integerValue > 0;
}];
XCTAssertEqualObjects(filteredArray, @[ @13, @42 ]);
```

### First

Returns the first element in the collection that satisfies a condition.

```objectivec
NSNumber *firstValue = [@[ @13, @42, @100 ] fbl_first:^BOOL(NSNumber *value) {
  return value.integerValue > 20;
}];
XCTAssertEqualObjects(firstValue, @42);
```

### FlatMap

Similar to [`map`](#map), but can also flatten a collection of collections.

```objectivec
NSArray<NSArray<NSNumber *> *> *originalArray = @[ @[ @13, @42 ], @[ @14, @43 ], @[] ];
NSArray<NSNumber *> *flatMappedArray = [originalArray fbl_flatMap:^id(NSArray<NSNumber *> *value) {
  return value.count > 0 ? value : nil;
}];
XCTAssertEqualObjects(flatMappedArray, @[ @13, @42, @14, @43 ]);
```

### ForEach

Invokes a block on each element of the collection in the same order as a for-in
loop.

```objectivec
[@[ @13, @42, @100 ] fbl_forEach:^(NSNumber *value) {
  // Invokes this block for values @13, @42, @100
}];
```

### Map

Loops over a collection and applies the same operation to each element in the
collection.

```objectivec
NSArray<NSString *> *mappedArray = [@[ @13, @42, @0 ] fbl_map:^id(NSNumber *value) {
  if (value.integerValue == 0) {
    return nil;
  }
  return value.stringValue;
}];
XCTAssertEqualObjects(mappedArray, @[ @"13", @"42", [NSNull null] ]);
```

### Reduce

Combines all items in a collection to create a single value.

```objectivec
NSNumber *reducedValue =
    [@[ @13, @42, @100 ] fbl_reduce:@0
                            combine:^NSNumber *(NSNumber *accumulator, NSNumber *value) {
                              return @(accumulator.integerValue + value.integerValue);
                            }];
XCTAssertEqualObjects(reducedValue, @(13 + 42 + 100));
```

### Zip

Creates an array of pairs built from the two input collections.

```objectivec
NSArray<NSArray *> *zippedArray = [@[ @13, @42, @101 ] fbl_zip:@[ @"100", @"14" ]];
XCTAssertEqualObjects(zippedArray, @[ @[ @13, @"100" ], @[ @42, @"14" ] ]);
```

## Setup

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'FunctionalObjC', '~> 1.0'
```

Or, if you would also like to include the tests:

```ruby
pod 'FunctionalObjC', '~> 1.0', :testspecs => ['Tests']
```

Then, run `pod install`.

### Carthage

Add the following to your `Cartfile`:

```
github "google/functional-objc"
```

Then, run `carthage update` and follow the [rest of instructions](https://github.com/Carthage/Carthage#getting-started).

### Import

Import the umbrella header as:

```objectivec
#import <FBLFunctional/FBLFunctional.h>
```

Or:

```objectivec
#import "FBLFunctional.h"
```

Or, the module:

```objectivec
@import FBLFunctional;
```
