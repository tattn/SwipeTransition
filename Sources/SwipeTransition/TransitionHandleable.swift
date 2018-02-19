//
//  TransitionHandleable.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180220.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

protocol TransitionHandleable: class {
    var interactiveTransition: InteractiveTransition? { get set }
    var allowsTransitionStart: Bool { get }

    func startTransition()
    func didStartTransition()
    func finishTransition()
    func didFinishTransition()
    func cancelTransition()
    func didCancelTransition()
}

extension TransitionHandleable {
    func startTransition() {
        guard allowsTransitionStart else { return }
        interactiveTransition = InteractiveTransition()
        didStartTransition()
    }

    func didStartTransition() {}

    func finishTransition() {
        interactiveTransition?.finish()
        interactiveTransition = nil
        didFinishTransition()
    }

    func didFinishTransition() {}

    func cancelTransition() {
        interactiveTransition?.cancel()
        interactiveTransition = nil
        didCancelTransition()
    }

    func didCancelTransition() {}
}
