//
//  ViewController.swift
//  Example
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import SwipeTransition

class PushableVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PushableVC"
        view.backgroundColor = .white

        let button = UIButton(frame: .init(x: 0, y: 0, width: 300, height: 50))
        button.center = view.center
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.setTitle("Push!", for: .normal)
        button.setTitleColor(.red, for: .normal)
        view.addSubview(button)
    }

    @objc func didTapButton() {
        self.navigationController?.pushViewController(PushableVC(), animated: true)
    }
}

final class PushableHidesBottomBarVC: PushableVC {
    override func didTapButton() {
        let vc = PushableHidesBottomBarVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

final class NoSwipeVC: PushableVC {
    private var previousIsBackSwipeEnabled: Bool!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previousIsBackSwipeEnabled = navigationController?.swipeBack?.isEnabled ?? false
        navigationController?.swipeBack?.isEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.swipeBack?.isEnabled = previousIsBackSwipeEnabled
    }

    override func didTapButton() {
        self.navigationController?.pushViewController(NoSwipeVC(), animated: true)
    }
}

class DismissTopVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let buttons: [Selector] = [
            #selector(dismissSimpleVC),
            #selector(dismissSimpleNC),
            #selector(swipeableNC),
            #selector(dismissTableVC),
            #selector(dismissScrollVC)
        ]

        buttons.enumerated().forEach {
            let button = UIButton(frame: .init(x: 0, y: 0, width: 300, height: 50))
            button.center.x = view.center.x
            button.frame.origin.y = view.frame.height / CGFloat(buttons.count + 1) * CGFloat($0.offset + 1) - button.frame.height / 2
            button.addTarget(self, action: $0.element, for: .touchUpInside)
            button.setTitle($0.element.description, for: .normal)
            button.setTitleColor(.red, for: .normal)
            view.addSubview(button)
        }
    }

    @objc func dismissSimpleVC() {
        let vc = DismissSimpleVC()
        present(vc, animated: true, completion: nil)
    }

    @objc func dismissSimpleNC() {
        let vc = UIViewController()
        vc.title = "DismissSimpleNC"
        vc.view.backgroundColor = .orange
        let nav = UINavigationController(rootViewController: vc)
        nav.swipeToDismiss = SwipeToDismissController(viewController: nav)
        present(nav, animated: true, completion: nil)
    }

    @objc func swipeableNC() {
        let vc = UIViewController()
        vc.title = "SwipeableNC"
        vc.view.backgroundColor = .orange
        let nav = SwipeToDismissNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    @objc func dismissTableVC() {
        let vc = TableVC()
        vc.title = "TableVC"
        vc.view.backgroundColor = .orange
        let nav = UINavigationController(rootViewController: vc)
        nav.swipeToDismiss = SwipeToDismissController(viewController: nav)
        present(nav, animated: true, completion: nil)
    }

    @objc func dismissScrollVC() {
        let vc = DismissScrollVC2()
        let nav = SwipeToDismissNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}

class DismissSimpleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DismissSimpleVC"
        view.backgroundColor = .orange
        swipeToDismiss = SwipeToDismissController(viewController: self)
    }
}

class TableVC: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Cell\(indexPath.row)"
        return cell
    }
}

class ScrollVC: UIViewController {

    weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        self.scrollView = scrollView

        let contentView = UIView(frame: view.bounds)
        contentView.frame.size.height = view.frame.height * 2
        scrollView.contentSize.height = contentView.frame.height
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.07, green: 0.13, blue: 0.26, alpha: 1).cgColor, UIColor(red: 0.54, green: 0.74, blue: 0.74, alpha: 1).cgColor]
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        let redView = UIView.init(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 30))
        redView.backgroundColor = .red
        contentView.addSubview(redView)
        scrollView.addSubview(contentView)
    }
}

class DismissScrollVC2: ScrollVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DismissScrollVC2"

        let button = UIButton(frame: .init(x: 0, y: 0, width: 300, height: 50))
        button.center = view.center
        button.addTarget(self, action: #selector(pushVC), for: .touchUpInside)
        button.setTitle("Push!", for: .normal)
        button.setTitleColor(.red, for: .normal)
        view.addSubview(button)
    }

    @objc func pushVC() {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }
}
