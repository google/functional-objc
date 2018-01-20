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

#import "NSDictionary+FBLFunctional.h"

#import <XCTest/XCTest.h>

@interface NSDictionaryFBLFunctionalTests : XCTestCase
@end

@implementation NSDictionaryFBLFunctionalTests

- (void)testFilterDictionary {
  // Arrange.
  NSDictionary<NSString *, NSNumber *> *originalDictionary = @{ @"1" : @12, @"2" : @40, @"0" : @0 };
  NSDictionary<NSString *, NSNumber *> *expectedDictionary = @{ @"1" : @12, @"2" : @40 };

  // Act.
  NSDictionary<NSString *, NSNumber *> *resultingDictionary =
      [originalDictionary fbl_filter:^BOOL(NSString __unused *_, NSNumber *value) {
        return value.integerValue > 0;
      }];

  // Assert.
  XCTAssertEqualObjects(resultingDictionary, expectedDictionary);
}

- (void)testFirstDictionary {
  // Arrange.
  NSDictionary<NSString *, NSNumber *> *originalDictionary = @{ @"1" : @13, @"2" : @42, @"3" : @0 };
  NSString *expectedKey = @"2";

  // Act.
  NSString *resultingKey =
      [originalDictionary fbl_first:^BOOL(NSString __unused *_, NSNumber *value) {
        return value.integerValue > 20;
      }];

  // Assert.
  XCTAssertEqualObjects(resultingKey, expectedKey);
}

- (void)testForEachDictionary {
  // Arrange.
  NSDictionary<NSString *, NSNumber *> *originalDictionary = @{ @"1" : @13, @"2" : @42, @"3" : @0 };
  NSMutableDictionary<NSString *, NSNumber *> *expectedDictionary =
      [[NSMutableDictionary alloc] init];

  // Act.
  [originalDictionary fbl_forEach:^(NSString *key, NSNumber *value) {
    expectedDictionary[key] = value;
  }];

  // Assert.
  XCTAssertEqualObjects(originalDictionary, expectedDictionary);
}

- (void)testFlatMapDictionary {
  // Arrange.
  NSDictionary<NSNumber *, NSDictionary<NSString *, NSNumber *> *> *originalDictionary =
      @{ @1 : @{@"1" : @13},
         @2 : @{@"2" : @42},
         @3 : @{} };
  NSArray<NSDictionary<NSString *, NSNumber *> *> *expectedArray = @[
    @{ @"1" : @13 },
    @{ @"2" : @42 }
  ];

  // Act.
  NSArray<NSDictionary<NSString *, NSNumber *> *> *resultingArray = [originalDictionary
      fbl_flatMap:^id(NSNumber *key, NSDictionary<NSString *, NSNumber *> *value) {
        return value.count > 0 ? @{key : value} : nil;
      }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testMapDictionary {
  // Arrange.
  NSDictionary<NSString *, NSNumber *> *originalDictionary = @{ @"1" : @12, @"2" : @40, @"0" : @0 };
  NSArray<NSString *> *expectedArray = @[ @"13", @"42", (NSString *)[NSNull null] ];

  // Act.
  NSArray<NSString *> *resultingArray =
      [originalDictionary fbl_map:^id(NSString *key, NSNumber *value) {
        NSInteger sum = key.integerValue + value.integerValue;
        if (sum == 0) {
          return nil;
        }
        return @(sum).stringValue;
      }];

  // Assert.
  XCTAssertEqualObjects(resultingArray, expectedArray);
}

- (void)testMapValuesDictionary {
  // Arrange.
  NSDictionary<NSNumber *, NSArray<NSNumber *> *> *originalDictionary =
      @{ @1 : @[ @1, @12 ],
         @2 : @[ @2, @40 ],
         @3 : @[ @3 ] };
  NSDictionary<NSNumber *, NSString *> *expectedDictionary =
      @{ @1 : @"13",
         @2 : @"42",
         @3 : (NSString *)[NSNull null] };

  // Act.
  NSDictionary<NSNumber *, NSString *> *resultingDictionary =
      [originalDictionary fbl_mapValues:^id(NSArray<NSNumber *> *value) {
        return value.count == 2 ?
            @(value.firstObject.integerValue + value.lastObject.integerValue).stringValue :
            nil;
      }];

  // Assert.
  XCTAssertEqualObjects(resultingDictionary, expectedDictionary);
}

- (void)testZipDictionary {
  // Arrange.
  NSDictionary<NSString *, NSNumber *> *dictionary1 = @{ @"1" : @12, @"2" : @40, @"0" : @0 };
  NSDictionary<NSString *, NSString *> *dictionary2 = @{@"3" : @"13", @"4" : @"42"};
  NSUInteger expectedCount = MIN(dictionary1.count, dictionary2.count);

  // Act.
  NSArray<NSArray *> *resultingArray = [dictionary1 fbl_zip:dictionary2];

  // Assert.
  XCTAssertEqual(resultingArray.count, expectedCount);
  NSArray<NSNumber *> *dict1Values = dictionary1.allValues;
  NSArray<NSString *> *dict2Values = dictionary2.allValues;
  for (NSArray *array in resultingArray) {
    XCTAssertTrue([dict1Values containsObject:array.firstObject]);
    XCTAssertTrue([dict2Values containsObject:array.lastObject]);
  }
}

- (void)testZipDictionaryWithDifferentContainerTypes {
  // Arrange.
  NSDictionary<NSString *, NSNumber *> *dictionary = @{ @"1" : @12, @"2" : @40 };
  NSArray<NSString *> *array1 = @[ @"13", @"42", @"0" ];
  NSUInteger expectedCount = MIN(dictionary.count, array1.count);

  // Act.
  NSArray<NSArray *> *resultingArray = [dictionary fbl_zip:array1];

  // Assert.
  XCTAssertEqual(resultingArray.count, expectedCount);
  NSArray<NSNumber *> *dictValues = dictionary.allValues;
  for (NSArray *array in resultingArray) {
    XCTAssertTrue([dictValues containsObject:array.firstObject]);
    XCTAssertTrue([array1 containsObject:array.lastObject]);
  }
}

@end
