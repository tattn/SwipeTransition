SwipeTransition
===

[![Build Status](https://travis-ci.org/tattn/SwipeTransition.svg?branch=master)](https://travis-ci.org/tattn/SwipeTransition)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![pods](https://img.shields.io/cocoapods/v/SwipeTransition.svg)
[![Platform](https://img.shields.io/cocoapods/p/SwipeTransition.svg)](http://cocoapods.org/pods/SwipeTransition)
[![Swift Version](https://img.shields.io/badge/Swift-4-F16D39.svg)](https://developer.apple.com/swift)
[![Objective-C compatible](https://img.shields.io/badge/Objective--C-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

SwipeTransition allows trendy transitions using swipe gesture such as "swipe back".

<img src="https://github.com/tattn/SwipeTransition/raw/master/docs/assets/demo.gif" alt="Demo" width="50%" />

Try the demo on the web (appetize.io):　https://appetize.io/app/ku7vwyq8ud61fdezt7njpw8r7m

# Usage

## The easiest way to use

Just setting these frameworks in the `Linked Frameworks and Libraries`, it works. (if you use Carthage)

![Linked Frameworks and Libraries](https://github.com/tattn/SwipeTransition/raw/master/docs/assets/linked_frameworks.png)

Notes: these frameworks use Method Swizzling.

When setting manually without Method Swizzling, please use `SwipeTransition.framework` only.

## Features

- [x] Swipe back anywhere.
- [x] Swipe to dismiss anywhere.
- [x] Apply to all view controllers automatically!

# Requirements

- Xcode 9.x
- Swift 4.x
- iOS 8.0+

# Installation

## Carthage

```ruby
github "tattn/SwipeTransition"
```

## CocoaPods

```ruby
pod "SwipeTransition"
pod "SwipeTransitionAutoSwipeBack"      # if needed
pod "SwipeTransitionAutoSwipeToDismiss" # if needed
```

## Swipe back

*Notes: when you use `AutoSwipeBack.framework`, these are unnecessary.*

Just use `SwipeBackNavigationController` instead of `UINavigationController`. Of course, you can set it with Interface Builder.

```swift
let viewController = UIViewController()
let navigationController = SwipeBackNavigationController(rootViewControlelr: viewController)
````

Another way is to set `swipeBack`.

```swift
class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack = SwipeBackController(navigationController: self)
    }
}
```

## Swipe to dismiss

### Make it work on UIScrollview

```swift
class TableVC: UIViewController, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        swipeToDismiss?.setScrollViews([tableView])
        
        // in case of presenting a navigationController
        // navigationController?.swipeToDismiss?.setScrollViews([tableView])
    }
}
```

### Manually setting

*Notes: when you use `AutoSwipeToDismiss.framework`, these are unnecessary.*

Just use `SwipeToDismissNavigationController` instead of `UINavigationController`. Of course, you can set it with Interface Builder.

```swift
let viewController = UIViewController()
let navigationController = SwipeToDismissNavigationController(rootViewControlelr: viewController)
````

Another way is to set `swipeToDismiss`.

```swift
class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        swipeToDismiss = SwipeToDismissController(viewController: self)
    }
}
```

## Enable/Disable gestures

Use `isEnabled` property.

```swift
navigationController?.swipeBack?.isEnabled = false
navigationController?.swipeToDismiss?.isEnabled = false
```

## Configuration

You can also change the behavior such as animation.

```swift
SwipeBackConfiguration.shared.parallaxFactor = 0.6

SwipeToDismissConfiguration.shared.dismissHeightRatio = 0.5
```

Inheriting the configure class, you can set it with computed property.

```swift
class CustomSwipeBackConfiguration: SwipeBackConfiguration {
    override var transitionDuration: TimeInterval {
        get { return 1.5 }
        set { super.transitionDuration = newValue }
    }
}

SwipeBackConfiguration.shared = CustomSwipeBackConfiguration()
```

## Other usage

See [this wiki](https://github.com/tattn/SwipeTransition/wiki)

# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

SwipeTransition is released under the MIT license. See LICENSE for details.
