//
//  PresentationController.swift
//  Slide
//
//  Created by Steve on 2017/8/1.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    var direction: Direction = .left
    var sideScale: CGFloat = 1.0 / 3.0

    // MARK: - Initializers
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = super.frameOfPresentedViewInContainerView
        switch direction {
        case .right:
            frame.origin.x = frame.size.width * (1 - sideScale)
            break
        case .left:
            break
        }
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        return frame
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        var size = CGSize.zero
        switch direction {
        case .left:
            size = CGSize(width: parentSize.width * sideScale, height: parentSize.height)
            break
        case .right:
            size = CGSize(width: parentSize.width, height: parentSize.height)
            break
        }
        return size
    }

    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    @objc lazy var dimmingView: UIView = {
        let dimming = UIView()
        dimming.translatesAutoresizingMaskIntoConstraints = false
        dimming.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimming.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimming.addGestureRecognizer(recognizer)
        return dimming
    }()

    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}

