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

#import "NSSet+FBLFunctional.h"

#import <XCTest/XCTest.h>

@interface NSSetFBLFunctionalTests : XCTestCase
@end

@implementation NSSetFBLFunctionalTests

- (void)testFilterSet {
  // Arrange.
  NSSet<NSNumber *> *originalSet = [NSSet setWithArray:@[ @13, @42, @0 ]];
  NSArray<NSNumber *> *expectedArray = @[ @13, @42 ];

  // Act.
  NSSet<NSNumber *> *resultingSet = [originalSet fbl_filter:^BOOL(NSNumber *value) {
    return value.integerValue > 0;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingSet, [NSSet setWithArray:expectedArray]);
}

- (void)testFirstSet {
  // Arrange.
  NSSet<NSNumber *> *originalSet = [NSSet setWithArray:@[ @13, @42, @100 ]];
  NSNumber *expectedValue = @42;

  // Act.
  NSNumber *resultingValue = [originalSet fbl_first:^BOOL(NSNumber *value) {
    return value.integerValue > 20;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingValue, expectedValue);
}

- (void)testFlatMapSet {
  // Arrange.
  NSSet<NSSet<NSNumber *> *> *originalSet = [NSSet setWithArray:@[
    [NSSet setWithArray:@[ @13, @42 ]], [NSSet setWithArray:@[ @14, @43 ]], [NSSet setWithArray:@[]]
  ]];
  NSArray<NSNumber *> *expectedArray = @[ @13, @42, @14, @43 ];

  // Act.
  NSArray<NSNumber *> *resultingArray = [originalSet fbl_flatMap:^id(NSSet<NSNumber *> *value) {
    return value.count > 0 ? value : nil;
  }];

  // Assert.
  XCTAssertEqualObjects([NSSet setWithArray:resultingArray], [NSSet setWithArray:expectedArray]);
}

- (void)testForEachSet {
  // Arrange.
  NSSet<NSNumber *> *originalSet = [NSSet setWithArray:@[ @13, @42, @100 ]];
  NSMutableArray<NSNumber *> *expectedArray = [[NSMutableArray alloc] init];

  // Act.
  [originalSet fbl_forEach:^(NSNumber *value) {
    [expectedArray addObject:value];
  }];

  // Assert.
  XCTAssertEqualObjects(originalSet, [NSSet setWithArray:expectedArray]);
}

- (void)testMapSet {
  // Arrange.
  NSSet<NSNumber *> *originalSet = [NSSet setWithArray:@[ @13, @42, @0 ]];
  NSArray<NSString *> *expectedArray = @[ @"13", @"42", (NSString *)[NSNull null] ];

  // Act.
  NSArray<NSString *> *resultingArray = [originalSet fbl_map:^id(NSNumber *value) {
    if (value.integerValue == 0) {
      return nil;
    }
    return value.stringValue;
  }];

  // Assert.
  XCTAssertEqualObjects([NSSet setWithArray:resultingArray], [NSSet setWithArray:expectedArray]);
}

- (void)testReduceSet {
  // Arrange.
  NSSet<NSNumber *> *originalSet = [NSSet setWithArray:@[ @13, @42, @100 ]];
  NSNumber *expectedValue = @(13 + 42 + 100);

  // Act.
  NSNumber *resultingValue =
      [originalSet fbl_reduce:@0
                      combine:^NSNumber *(NSNumber *accumulator, NSNumber *value) {
                        return @(accumulator.integerValue + value.integerValue);
                      }];

  // Assert.
  XCTAssertEqualObjects(resultingValue, expectedValue);
}

- (void)testZipSet {
  // Arrange.
  NSSet<NSNumber *> *set1 = [NSSet setWithArray:@[ @13, @42 ]];
  NSSet<NSString *> *set2 = [NSSet setWithArray:@[ @"100", @"14", @"43" ]];
  NSUInteger expectedCount = MIN(set1.count, set2.count);

  // Act.
  NSArray<NSArray *> *resultingArray = [set1 fbl_zip:set2];

  // Assert.
  XCTAssertEqual(resultingArray.count, expectedCount);
  for (NSArray *array in resultingArray) {
    XCTAssertTrue([set1 containsObject:array.firstObject]);
    XCTAssertTrue([set2 containsObject:array.lastObject]);
  }
}

- (void)testZipSetWithDifferentContainerTypes {
  // Arrange.
  NSSet<NSNumber *> *set = [NSSet setWithArray:@[ @13, @42 ]];
  NSArray<NSString *> *array = @[ @"100", @"14", @"43" ];
  NSUInteger expectedCount = MIN(set.count, array.count);

  // Act.
  NSArray<NSArray *> *resultingArray = [set fbl_zip:array];

  // Assert.
  XCTAssertEqual(resultingArray.count, expectedCount);
  for (NSArray *array in resultingArray) {
    XCTAssertTrue([set containsObject:array.firstObject]);
    XCTAssertTrue([array containsObject:array.lastObject]);
  }
}

@end
