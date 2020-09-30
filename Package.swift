// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwipeTransition",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwipeTransition",
            targets: ["SwipeTransition"]
        )
    ],
    targets: [
        .target(
            name: "SwipeTransition",
            dependencies: ["DelegateProxy"],
            path: "Sources/SwipeTransition"
        ),
        .target(
            name: "Automation",
            path: "Sources/Automation"
        ),
        .target(
            name: "DelegateProxy",
            path: "Sources/DelegateProxy"
        )
    ]
)
