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

#import "NSArray+FBLFunctional.h"

#import <XCTest/XCTest.h>

@interface NSArrayFBLFunctionalTests : XCTestCase
@end

@implementation NSArrayFBLFunctionalTests

- (void)testFilterArray {
  // Arrange.
  NSArray<NSNumber *> *originalArray = @[ @13, @42, @0 ];
  NSArray<NSNumber *> *expectedArray = @[ @13, @42 ];

  // Act.
  NSArray<NSNumber *> *resultingArray = [originalArray fbl_filter:^BOOL(NSNumber *value) {
    return value.integerValue > 0;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testFirstArray {
  // Arrange.
  NSArray<NSNumber *> *originalArray = @[ @13, @42, @100 ];
  NSNumber *expectedValue = @42;

  // Act.
  NSNumber *resultingValue = [originalArray fbl_first:^BOOL(NSNumber *value) {
    return value.integerValue > 20;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingValue, expectedValue);
}

- (void)testFlatMapArray {
  // Arrange.
  NSArray<NSArray<NSNumber *> *> *originalArray = @[ @[ @13, @42 ], @[ @14, @43 ], @[] ];
  NSArray<NSNumber *> *expectedArray = @[ @13, @42, @14, @43 ];

  // Act.
  NSArray<NSNumber *> *resultingArray = [originalArray fbl_flatMap:^id(NSArray<NSNumber *> *value) {
    return value.count > 0 ? value : nil;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testForEachArray {
  // Arrange.
  NSArray<NSNumber *> *originalArray = @[ @13, @42, @100 ];
  NSMutableArray<NSNumber *> *resultingArray = [[NSMutableArray alloc] init];

  // Act.
  [originalArray fbl_forEach:^(NSNumber *value) {
    [resultingArray addObject:value];
  }];

  // Assert.
  XCTAssertEqualObjects(originalArray, resultingArray);
}

- (void)testMapArray {
  // Arrange.
  NSArray<NSNumber *> *originalArray = @[ @13, @42, @0 ];
  NSArray<NSString *> *expectedArray = @[ @"13", @"42", (NSString *)[NSNull null] ];

  // Act.
  NSArray<NSString *> *resultingArray = [originalArray fbl_map:^id(NSNumber *value) {
    if (value.integerValue == 0) {
      return nil;
    }
    return value.stringValue;
  }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testReduceArray {
  // Arrange.
  NSArray<NSNumber *> *originalArray = @[ @13, @42, @100 ];
  NSNumber *expectedValue = @(13 + 42 + 100);

  // Act.
  NSNumber *resultingValue =
      [originalArray fbl_reduce:@0
                        combine:^NSNumber *(NSNumber *accumulator, NSNumber *value) {
                          return @(accumulator.integerValue + value.integerValue);
                        }];

  // Assert.
  XCTAssertEqualObjects(resultingValue, expectedValue);
}

- (void)testZipArray {
  // Arrange.
  NSArray<NSNumber *> *array1 = @[ @13, @42, @101 ];
  NSArray<NSString *> *array2 = @[ @"100", @"14" ];
  NSArray<NSArray *> *expectedArray = @[ @[ @13, @"100" ], @[ @42, @"14" ] ];

  // Act.
  NSArray<NSArray *> *resultingArray = [array1 fbl_zip:array2];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testZipArrayWithDifferentContainerTypes {
  // Arrange.
  NSArray<NSNumber *> *array = @[ @13, @42, @101 ];
  NSSet<NSNumber *> *set = [NSSet setWithArray:@[ @13, @42 ]];
  NSUInteger expectedCount = MIN(array.count, set.count);

  // Act.
  NSArray<NSArray *> *resultingArray = [array fbl_zip:set];

  // Assert.
  XCTAssertEqual(resultingArray.count, expectedCount);
  for (NSArray *array in resultingArray) {
    XCTAssertTrue([array containsObject:array.firstObject]);
    XCTAssertTrue([set containsObject:array.lastObject]);
  }
}

@end
