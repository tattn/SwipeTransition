// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "SwipeTransition",
  products: [
    .library(
      name: "SwipeTransition",
      targets: ["SwipeTransition"])
  ],
  targets: [
    .target(
      name: "SwipeTransition",
      path: "Sources/SwipeTransition")
  ]
)
