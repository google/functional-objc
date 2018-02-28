package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")

OBJC_COPTS = [
    "-Wall",
    "-Wextra",
    "-Werror",
]

objc_library(
    name = "FBLFunctional",
    srcs = glob([
        "Sources/FBLFunctional/*.m",
    ]),
    hdrs = glob([
        "Sources/FBLFunctional/include/*.h",
    ]) + [
        "FBLFunctional.h",
    ],
    copts = OBJC_COPTS,
    includes = [
        "Sources/FBLFunctional/include",
    ],
)

ios_unit_test(
    name = "Tests",
    minimum_os_version = "8.0",
    deps = [
        ":FBLFunctionalTests",
    ],
)

objc_library(
    name = "FBLFunctionalTests",
    testonly = 1,
    srcs = glob([
        "Tests/FBLFunctionalTests/*.m",
    ]),
    copts = OBJC_COPTS,
    deps = [
        ":FBLFunctional",
    ],
)
