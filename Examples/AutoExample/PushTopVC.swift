//
//  PushTopVC.swift
//  AutoExample
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import SwipeTransition
import WebKit

class PushTopVC: UIViewController {

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

        navigationController?.swipeBack?.observePageViewController(pageViewController) { [unowned self] in self.index == 0 }
    }
}

extension PushTopVC: UIPageViewControllerDataSource {
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


class WebVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        webView.loadRequest(.init(url: URL(string: "https://github.com/tattn/SwipeTransition")!))
    }
}

class WKWebVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        webView.load(.init(url: URL(string: "https://github.com/tattn/SwipeTransition")!))
    }
}
