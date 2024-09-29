// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "SwipeTransition",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SwipeTransition",
            targets: ["SwipeTransition"]
        ),
        .library(
            name: "AutoSwipeBack",
            targets: ["AutoSwipeBack"]
        ),
        .library(
            name: "AutoSwipeToDismiss",
            targets: ["AutoSwipeToDismiss"]
        )
    ],
    targets: [
        .target(
            name: "SwipeTransition",
            dependencies: ["STDelegateProxy"],
            path: "Sources/SwipeTransition"
        ),
        .target(
            name: "STDelegateProxy",
            path: "Sources/DelegateProxy"
        ),
         .target(
             name: "AutoSwipeBack",
             dependencies: ["SwipeTransition"],
             path: "Sources/Automation/AutoSwipeBack",
             exclude: ["Info.plist", "AutoSwipeBack.h"]
         ),
        .target(
            name: "AutoSwipeToDismiss",
            dependencies: ["SwipeTransition"],
            path: "Sources/Automation/AutoSwipeToDismiss",
            exclude: ["Info.plist", "AutoSwipeToDismiss.h"]
        )
    ]
)
