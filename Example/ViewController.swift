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
        previousIsBackSwipeEnabled = navigationController?.isBackSwipeEnabled ?? false
        navigationController?.isBackSwipeEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isBackSwipeEnabled = previousIsBackSwipeEnabled
    }

    override func didTapButton() {
        self.navigationController?.pushViewController(NoSwipeVC(), animated: true)
    }
}
