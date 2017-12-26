//
//  ViewController.swift
//  AutoExample
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import SwipeTransition

class ViewController: UIViewController {

    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageViewController.view)
        view.backgroundColor = .green
        pageViewController.view.frame = view.bounds
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        pageViewController.dataSource = self
        addChildViewController(pageViewController)
        pageViewController.setViewControllers([ContentVC()], direction: .forward, animated: false, completion: nil)

        let scrollView = pageViewController.view.subviews
            .lazy
            .flatMap { $0 as? UIScrollView }
            .first

        navigationController?.swipeBack?.delegate = self
        navigationController?.swipeBack?.setScrollViews([scrollView!])
    }
}

extension ViewController: BackSwipeControllerDelegate {
    func backSwipeControllerIsFirstPageOfPageViewController() -> Bool {
        return index == 0
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard index > 0 else { return nil }
        index -= 1
        return ContentVC()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        index += 1
        return ContentVC()
    }
}

class ContentVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 5
    }
}
