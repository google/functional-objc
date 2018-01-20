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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet<ObjectType>(FBLFunctionalAdditions)

typedef void (^FBLFunctionalSetEnumeratorBlock)(ObjectType value);
typedef id __nullable (^FBLFunctionalSetMapperBlock)(ObjectType value);
typedef BOOL (^FBLFunctionalSetPredicateBlock)(ObjectType value);
typedef id __nullable (^FBLFunctionalSetReducerBlock)(id __nullable accumulator, ObjectType value);

/**
 Returns a set containing receiver's elements that satisfy the given predicate.
 */
- (instancetype)fbl_filter:(NS_NOESCAPE FBLFunctionalSetPredicateBlock)predicate
    NS_SWIFT_UNAVAILABLE("");

/**
 Returns the first element of the receiver that satisfies the given predicate.
 */
- (nullable ObjectType)fbl_first:(NS_NOESCAPE FBLFunctionalSetPredicateBlock)predicate
    NS_SWIFT_UNAVAILABLE("");

/**
 Returns an array containing the results of mapping the given mapper over receiver’s elements.
 Mapped nil is ignored. Mapped NSSet is flattened: its elements are appended to the results.
 */
- (NSArray *)fbl_flatMap:(NS_NOESCAPE FBLFunctionalSetMapperBlock)mapper NS_SWIFT_UNAVAILABLE("");

/**
 Calls the given block on each element of the receiver in the same order as a for-in loop.
 */
- (void)fbl_forEach:(NS_NOESCAPE FBLFunctionalSetEnumeratorBlock)block NS_SWIFT_UNAVAILABLE("");

/**
 Returns an array containing the results of mapping the given mapper over receiver’s elements.
 Mapped nil appears as NSNull in resulting array.
 */
- (NSArray *)fbl_map:(NS_NOESCAPE FBLFunctionalSetMapperBlock)mapper NS_SWIFT_UNAVAILABLE("");

/**
 Returns the result of combining receiver's elements using the given reducer.
 */
- (nullable id)fbl_reduce:(nullable id)initial
                  combine:(NS_NOESCAPE FBLFunctionalSetReducerBlock)reducer
    NS_SWIFT_UNAVAILABLE("");

/**
 Returns an array of pairs built out of the receiver's and provided elements. If the two containers
 have different counts, the resulting array is the same count as the shorter container.
 */
- (NSArray<NSArray *> *)fbl_zip:(id)container NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
