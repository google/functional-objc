// swift-tools-version:4.0
// swiftlint:disable trailing_comma

// To generate and open project in Xcode run:
// swift package generate-xcodeproj && open FBLFunctional.xcodeproj

// Copyright 2018 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import PackageDescription

let package = Package(
  name: "FBLFunctional",
  products: [
    .library(
      name: "FBLFunctional",
      targets: ["FBLFunctional"]
    )
  ],
  targets: [
    .target(
      name: "FBLFunctional"
    ),
    .testTarget(
      name: "FBLFunctionalTests",
      dependencies: [
        "FBLFunctional",
      ]
    ),
  ]
)
