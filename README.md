SwipeTransition
===

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Version](https://img.shields.io/badge/Swift-4-F16D39.svg)](https://developer.apple.com/swift)

SwipeTransition allows trendy transitions using swipe gesture such as "swipe back".

<img src="https://github.com/tattn/SwipeTransition/raw/master/docs/assets/demo.gif" alt="Demo" width="50%" />

# Usage

## The easiest way to use

Just setting these frameworks in the Embedded Binaries, it works.

![Embedded Binaries](https://github.com/tattn/SwipeTransition/raw/master/docs/assets/embedded_binaries.png)

Notes: these frameworks use Method Swizzling.

When setting manually, please use `SwipeTransition.framework`.

## Swipe back

Just use `BackSwipeableNavigationController` instead of `UINavigationController`. Of course, you can set it with Interface Builder.

```swift
let viewController = UIViewController()
let navigationController = BackSwipeableNavigationController(rootViewControlelr: viewController)
````

Another way is to use a `BackSwipeable` protocol.

```swift
class CustomNavigationController: UINavigationController, BackSwipeable {
    override func viewDidLoad() {
        super.viewDidLoad()
        backSwipeController = BackSwipeController(navigationController: self)
    }
}
```

Notes: it's unavailable using `Auto*.framework`.

### Configuration

It is possible to disable the feature only for a specific view controller.

```swift
class NoSwipeVC: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.swipeBack?.isEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.swipeBack?.isEnabled = true
    }
}
```

## Swipe to dismiss

Just use `SwipeableToDismissNavigationController` instead of `UINavigationController`. Of course, you can set it with Interface Builder.

```swift
let viewController = UIViewController()
let navigationController = SwipeableToDismissNavigationController(rootViewControlelr: viewController)
````

Another way is to use a `BackSwipeable` protocol.

```swift
class CustomNavigationController: UINavigationController, SwipeableToDismiss {
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        configureSwipeToDismiss()
    }
}
```

Notes: it's unavailable using `Auto*.framework`.

### Configuration

It is possible to disable the feature only for a specific view controller.

```swift
class NoSwipeVC: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.swipeToDismiss?.isEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.swipeToDismiss?.isEnabled = true
    }
}
```

It also works on scroll view.

```swift
class ScrollVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        navigationController?.swipeToDismiss?.scrollView = scrollView
        
        // in case of multiple scroll views
        // navigationController?.swipeToDismiss?.setScrollViews(scrollViews)
    }
}
```

## Common Configuration

You can also change the behavior such as animation.

```swift
BackSwipeableConfiguration.shared.parallaxFactor = 0.6

SwipeToDismissConfiguration.shared.dismissHeightRatio = 0.5
```

Inheriting the configure class, you can set it with computed property.

```swift
class CustomBackSwipeableConfiguration: BackSwipeableConfiguration {
    override var transitionDuration: TimeInterval {
        get { return 1.5 }
        set { super.transitionDuration = newValue }
    }
}

BackSwipeableConfiguration.shared = CustomBackSwipeableConfiguration()
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
