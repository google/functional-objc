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
#import "NSOrderedSet+FBLFunctional.h"
#import "NSSet+FBLFunctional.h"

NSArray<NSArray *> *FBLZip(id container1, id container2) {
  NSMutableArray<NSArray *> *result = [[NSMutableArray alloc] init];
  NSEnumerator *enumerator1 = [container1 objectEnumerator];
  NSEnumerator *enumerator2 = [container2 objectEnumerator];
  for (;;) {
    id object1 = [enumerator1 nextObject];
    id object2 = [enumerator2 nextObject];
    if (!object1 || !object2) break;
    [result addObject:@[ object1, object2 ]];
  }
  return result;
}

static NSArray *FBLArrayFromContainer(id container) {
  NSArray *result = @[];
  if ([container isKindOfClass:[NSArray class]]) {
    result = container;
  } else if ([container isKindOfClass:[NSSet class]]) {
    result = [container allObjects];
  } else if ([container isKindOfClass:[NSOrderedSet class]]) {
    result = [container array];
  }
  return result;
}

/**
 Compares object classes similarly to isKindOfClass, which doesn't work for class clusters:
 NSArray<NSNumber *> isn't kind of class NSArray<NSString *> when two instances are compared.
 This method compares each instance to generic container class instead.
 */
static BOOL FBLSameKindContainers(id container1, id container2) {
  // Both containers are NSArrays.
  if ([container1 isKindOfClass:[NSArray class]] && [container2 isKindOfClass:[NSArray class]]) {
    return YES;
  }
  // Both containers are NSOrderedSets.
  if ([container1 isKindOfClass:[NSOrderedSet class]] &&
      [container2 isKindOfClass:[NSOrderedSet class]]) {
    return YES;
  }
  // Both containers are NSSets.
  if ([container1 isKindOfClass:[NSSet class]] && [container2 isKindOfClass:[NSSet class]]) {
    return YES;
  }
  return NO;
}

static id FBLFilter(id<NSFastEnumeration, NSObject> container, BOOL (^predicate)(id)) {
  id result = [[[container class] new] mutableCopy];
  for (id object in container) {
    if (predicate(object)) {
      [result addObject:object];
    }
  }
  return result;
}

static id __nullable FBLFirst(id<NSFastEnumeration> container, BOOL (^predicate)(id)) {
  for (id object in container) {
    if (predicate(object)) {
      return object;
    }
  }
  return nil;
}

static NSArray *FBLFlatMap(id<NSFastEnumeration, NSObject> container, id __nullable (^mapper)(id)) {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (id object in container) {
    id mapped = mapper(object);
    if (FBLSameKindContainers(container, mapped)) {
      [result addObjectsFromArray:FBLArrayFromContainer(mapped)];
    } else if (mapped) {
      [result addObject:mapped];
    }
  }
  return result;
}

static void FBLForEach(id<NSFastEnumeration> container, void (^block)(id)) {
  for (id object in container) {
    block(object);
  }
}

static NSArray *FBLMap(id<NSFastEnumeration> container, id __nullable (^mapper)(id)) {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (id object in container) {
    id mapped = mapper(object);
    [result addObject:mapped ?: [NSNull null]];
  }
  return result;
}

static id __nullable FBLReduce(id<NSFastEnumeration> container, id __nullable initialValue,
                               id __nullable (^reducer)(id __nullable, id)) {
  id result = initialValue;
  for (id object in container) {
    result = reducer(result, object);
  }
  return result;
}

/// Common implementation for NSArray, NSSet and NSOrderedSet to avoid boilerplate code.
@implementation NSObject (FBLFunctionalAdditions)

- (instancetype)fbl_filter:(BOOL (^)(id))predicate {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(predicate);

  return FBLFilter((id<NSFastEnumeration, NSObject>)self, predicate);
}

- (nullable id)fbl_first:(BOOL (^)(id))predicate {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(predicate);

  return FBLFirst((id<NSFastEnumeration>)self, predicate);
}

- (NSArray *)fbl_flatMap:(id (^)(id))mapper {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(mapper);

  return FBLFlatMap((id<NSFastEnumeration, NSObject>)self, mapper);
}

- (void)fbl_forEach:(void (^)(id))block {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(block);

  FBLForEach((id<NSFastEnumeration>)self, block);
}

- (NSArray *)fbl_map:(id (^)(id))mapper {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(mapper);

  return FBLMap((id<NSFastEnumeration>)self, mapper);
}

- (nullable id)fbl_reduce:(nullable id)initialValue combine:(id (^)(id, id))reducer {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(reducer);

  return FBLReduce((id<NSFastEnumeration>)self, initialValue, reducer);
}

- (NSArray<NSArray *> *)fbl_zip:(id)container {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert([container isKindOfClass:[NSArray class]] ||
                    [container isKindOfClass:[NSSet class]] ||
                    [container isKindOfClass:[NSOrderedSet class]]);

  return FBLZip(self, container);
}

@end
