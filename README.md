SwipeTransition
===

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Version](https://img.shields.io/badge/Swift-4-F16D39.svg)](https://developer.apple.com/swift)

SwipeTransition allows trendy transitions using swipe gesture such as "swipe back".

# Usage

## Swipe back

Just use BackSwipeableNavigationController instead of UINavigationController. Of course, you can set it with Interface Builder.

```swift
let viewController = UIViewController()
let navigationController = BackSwipeableNavigationController(rootViewControlelr: viewController)
````

Another way is to use a `BackSwipeable` protocol.

```swift
class CustomNavigationController: UINavigationController, BackSwipeable {
    open override func viewDidLoad() {
        super.viewDidLoad()
        backSwipeController = BackSwipeController(navigationController: self)
    }
}
```

It is possible to disable the feature only for a specific view controller.

```swift
class NoSwipeVC: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isBackSwipeEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isBackSwipeEnabled = true
    }
}
```

# Installation

## Carthage

```ruby
github "tattn/SwipeTransition"
```


# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

SwipeTransition is released under the MIT license. See LICENSE for details.
