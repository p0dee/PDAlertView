//
//  AlertView.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/19/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

//import Foundation
import UIKit

public class AlertView: UIView, AlertBodyViewDelegate {
    
    private let backgroundView = AlertBackgroundView() //lazyにしたい
    private let bodyView = AlertBodyView() //lazyにしたい
    private var actions = [AlertAction]()
    private var backgroundBottomConstraint: NSLayoutConstraint?
    
    var accessoryView: UIView? {
        didSet {
            guard accessoryView != oldValue else {
                return
            }
            for v in bodyView.accessoryContentView.subviews {
                v.removeFromSuperview()
            }
            if let accessoryView = accessoryView {
                bodyView.accessoryContentView.addSubview(accessoryView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHeightDidChange:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHeightDidChange:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(title: String?, message: String?) {
        self.init()
        bodyView.title = title
        bodyView.message = message
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func didMoveToSuperview() {
        guard self.superview != nil else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        let cstrs = NSLayoutConstraint.constraintsToFillSuperview(self)
        NSLayoutConstraint.activateConstraints(cstrs)
    }

    private func setupViews() {
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.delegate = self
        backgroundView.addSubview(bodyView)
    }
    
    private func setupConstraints() {
        var cstrs = [NSLayoutConstraint]()
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(backgroundView)
        backgroundBottomConstraint = cstrs.last
        cstrs.append(bodyView.centerXAnchor.constraintEqualToAnchor(backgroundView.centerXAnchor))
        cstrs.append(bodyView.centerYAnchor.constraintEqualToAnchor(backgroundView.centerYAnchor))
        NSLayoutConstraint.activateConstraints(cstrs)
    }
    
    @objc private func keyboardHeightDidChange(sender: NSNotification) {
        guard let backgroundBottomConstraint = backgroundBottomConstraint else {
            return
        }
        var delta: CGFloat = 0
        switch sender.name {
        case UIKeyboardWillShowNotification:
            if let info = sender.userInfo, let sz = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
                delta = -sz.height
            }
        case UIKeyboardWillHideNotification:
            delta = 0
        default:
            break
        }
        backgroundBottomConstraint.constant = delta
    }
    
    //MARK: public interface
    public func addAction(action: AlertAction) {
        actions.append(action)
        bodyView.addAction(action)
    }
    
    public func showOn(targetView: UIView) {
        targetView.addSubview(self)
        self.alpha = 0.0
        bodyView.alpha = 0.0
        bodyView.transform = CGAffineTransformMakeScale(320/270, 320/270)
        UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.alpha = 1.0
            self.bodyView.alpha = 1.0
            self.bodyView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    public func dismiss() {
        UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseOut, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    //MARK: <AlertBodyViewDelegate>
    internal func bodyView(bodyView: AlertBodyView, didSelectedItemAtIndex index: Int) {
        actions[index].handler?()
    }
    
}