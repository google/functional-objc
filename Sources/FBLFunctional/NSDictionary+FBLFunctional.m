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

FOUNDATION_EXTERN NSArray<NSArray *> *FBLZip(id container1, id container2);

static NSDictionary *FBLDictionaryFilter(NSDictionary *dictionary, BOOL (^predicate)(id, id)) {
  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  for (id key in dictionary) {
    id value = dictionary[key];
    if (predicate(key, value)) {
      result[key] = value;
    }
  }
  return result;
}

static id __nullable FBLDictionaryFirst(NSDictionary *dictionary, BOOL (^predicate)(id, id)) {
  for (id key in dictionary) {
    if (predicate(key, dictionary[key])) {
      return key;
    }
  }
  return nil;
}

static NSArray *FBLDictionaryFlatMap(NSDictionary *dictionary, id __nullable (^mapper)(id, id)) {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (id key in dictionary) {
    id mapped = mapper(key, dictionary[key]);
    if ([mapped isKindOfClass:[NSDictionary class]]) {
      [result addObjectsFromArray:[mapped allValues]];
    } else if (mapped) {
      [result addObject:mapped];
    }
  }
  return result;
}

static void FBLDictionaryForEach(NSDictionary *dictionary, void (^block)(id, id)) {
  for (id key in dictionary) {
    block(key, dictionary[key]);
  }
}

static NSArray *FBLDictionaryMap(NSDictionary *dictionary, id __nullable (^mapper)(id, id)) {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (id key in dictionary) {
    id mapped = mapper(key, dictionary[key]);
    [result addObject:mapped ?: [NSNull null]];
  }
  return result;
}

static NSDictionary *FBLDictionaryMapValues(NSDictionary *dictionary, id __nullable (^mapper)(id)) {
  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  for (id key in dictionary) {
    id mapped = mapper(dictionary[key]);
    result[key] = mapped ?: [NSNull null];
  }
  return result;
}

static id __nullable FBLDictionaryReduce(NSDictionary *dictionary, id __nullable initialValue,
                                         id __nullable (^reducer)(id __nullable, id, id)) {
  id result = initialValue;
  for (id key in dictionary) {
    result = reducer(result, key, dictionary[key]);
  }
  return result;
}

@implementation NSDictionary (FBLFunctionalAdditions)

- (instancetype)fbl_filter:(NS_NOESCAPE BOOL (^)(id, id))predicate {
  NSParameterAssert(predicate);

  return FBLDictionaryFilter(self, predicate);
}

- (nullable id)fbl_first:(NS_NOESCAPE BOOL (^)(id, id))predicate {
  NSParameterAssert(predicate);

  return FBLDictionaryFirst(self, predicate);
}

- (NSArray *)fbl_flatMap:(NS_NOESCAPE id (^)(id, id))mapper {
  NSParameterAssert(mapper);

  return FBLDictionaryFlatMap(self, mapper);
}

- (void)fbl_forEach:(NS_NOESCAPE void (^)(id, id))block {
  NSParameterAssert(block);

  FBLDictionaryForEach(self, block);
}

- (NSArray *)fbl_map:(NS_NOESCAPE id (^)(id, id))mapper {
  NSParameterAssert(mapper);

  return FBLDictionaryMap(self, mapper);
}

- (NSDictionary *)fbl_mapValues:(NS_NOESCAPE id (^)(id))mapper {
  NSParameterAssert(mapper);

  return FBLDictionaryMapValues(self, mapper);
}

- (nullable id)fbl_reduce:(nullable NS_NOESCAPE id)initialValue
                  combine:(NS_NOESCAPE id (^)(id, id, id))reducer {
  NSParameterAssert(reducer);

  return FBLDictionaryReduce(self, initialValue, reducer);
}

- (NSArray<NSArray *> *)fbl_zip:(id)container {
  NSParameterAssert([self isKindOfClass:[NSDictionary class]]);
  NSParameterAssert(
      [container isKindOfClass:[NSDictionary class]] || [container isKindOfClass:[NSArray class]] ||
      [container isKindOfClass:[NSSet class]] || [container isKindOfClass:[NSOrderedSet class]]);

  return FBLZip(self, container);
}

@end
