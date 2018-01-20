/**
 Copyright 2018 Google Inc. All rights reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at:

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "NSOrderedSet+FBLFunctional.h"

#import <XCTest/XCTest.h>

@interface NSOrderedSetFBLFunctionalTests : XCTestCase
@end

@implementation NSOrderedSetFBLFunctionalTests

- (void)testFilterOrderedSet {
  // Arrange.
  NSOrderedSet<NSNumber *> *originalOrderedSet =
      [NSOrderedSet orderedSetWithArray:@[ @13, @42, @0 ]];
  NSArray<NSNumber *> *expectedArray = @[ @13, @42 ];

  // Act.
  NSOrderedSet<NSNumber *> *resultingSet = [originalOrderedSet fbl_filter:^BOOL(NSNumber *value) {
    return value.integerValue > 0;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingSet, [NSOrderedSet orderedSetWithArray:expectedArray]);
}

- (void)testFirstOrderedSet {
  // Arrange.
  NSOrderedSet<NSNumber *> *originalOrderedSet =
      [NSOrderedSet orderedSetWithArray:@[ @13, @42, @100 ]];
  NSNumber *expectedValue = @42;

  // Act.
  NSNumber *resultingValue = [originalOrderedSet fbl_first:^BOOL(NSNumber *value) {
    return value.integerValue > 20;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingValue, expectedValue);
}

- (void)testFlatMapOrderedSet {
  // Arrange.
  NSOrderedSet<NSOrderedSet<NSNumber *> *> *originalOrderedSet =
      [NSOrderedSet orderedSetWithArray:@[
        [NSOrderedSet orderedSetWithArray:@[ @13, @42 ]],
        [NSOrderedSet orderedSetWithArray:@[ @14, @43 ]], [NSOrderedSet orderedSetWithArray:@[]]
      ]];
  NSArray<NSNumber *> *expectedArray = @[ @13, @42, @14, @43 ];

  // Act.
  NSArray<NSNumber *> *resultingArray =
      [originalOrderedSet fbl_flatMap:^id(NSOrderedSet<NSNumber *> *value) {
        return value.count > 0 ? value : nil;
      }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testForEachOrderedSet {
  // Arrange.
  NSOrderedSet<NSNumber *> *originalOrderedSet =
      [NSOrderedSet orderedSetWithArray:@[ @13, @42, @100 ]];
  NSMutableArray<NSNumber *> *expectedArray = [[NSMutableArray alloc] init];

  // Act.
  [originalOrderedSet fbl_forEach:^(NSNumber *value) {
    [expectedArray addObject:value];
  }];

  // Assert.
  XCTAssertEqualObjects(originalOrderedSet, [NSOrderedSet orderedSetWithArray:expectedArray]);
}

- (void)testMapOrderedSet {
  // Arrange.
  NSOrderedSet<NSNumber *> *originalOrderedSet =
      [NSOrderedSet orderedSetWithArray:@[ @13, @42, @0 ]];
  NSArray<NSString *> *expectedArray = @[ @"13", @"42", (NSString *)[NSNull null] ];

  // Act.
  NSArray<NSString *> *resultingArray = [originalOrderedSet fbl_map:^id(NSNumber *value) {
    if (value.integerValue == 0) {
      return nil;
    }
    return value.stringValue;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testReduceOrderedSet {
  // Arrange.
  NSOrderedSet<NSNumber *> *originalOrderedSet =
      [NSOrderedSet orderedSetWithArray:@[ @13, @42, @100 ]];
  NSNumber *expectedValue = @(13 + 42 + 100);

  // Act.
  NSNumber *resultingValue =
      [originalOrderedSet fbl_reduce:@0
                             combine:^NSNumber *(NSNumber *accumulator, NSNumber *value) {
                               return @(accumulator.integerValue + value.integerValue);
                             }];

  // Assert.
  XCTAssertEqualObjects(resultingValue, expectedValue);
}

- (void)testZipOrderedSet {
  // Arrange.
  NSOrderedSet<NSNumber *> *orderedSet1 = [NSOrderedSet orderedSetWithArray:@[ @13, @42 ]];
  NSOrderedSet<NSString *> *orderedSet2 =
      [NSOrderedSet orderedSetWithArray:@[ @"100", @"14", @"43" ]];
  NSArray<NSArray *> *expectedArray = @[ @[ @13, @"100" ], @[ @42, @"14" ] ];

  // Act.
  NSArray<NSArray *> *resultingArray = [orderedSet1 fbl_zip:orderedSet2];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testZipOrderedSetWithDifferentContainerTypes {
  // Arrange.
  NSOrderedSet<NSNumber *> *orderedSet = [NSOrderedSet orderedSetWithArray:@[ @13, @42 ]];
  NSSet<NSNumber *> *set = [NSSet setWithArray:@[ @14, @43, @100 ]];
  NSUInteger expectedCount = MIN(orderedSet.count, set.count);

  // Act.
  NSArray<NSArray *> *resultingArray = [orderedSet fbl_zip:set];

  // Assert.
  XCTAssertEqual(resultingArray.count, expectedCount);
  for (NSArray *array in resultingArray) {
    XCTAssertTrue([orderedSet containsObject:array.firstObject]);
    XCTAssertTrue([set containsObject:array.lastObject]);
  }
}

@end
