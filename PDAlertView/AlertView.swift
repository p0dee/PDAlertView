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
    
    private let backgroundView = AlertBackgroundView()
    private let bodyView = AlertBodyView()
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightDidChange(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightDidChange(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func didMoveToSuperview() {
        guard self.superview != nil else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        let cstrs = NSLayoutConstraint.constraintsToFillSuperview(self)
        NSLayoutConstraint.activate(cstrs)
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
        cstrs.append(bodyView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        cstrs.append(bodyView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor))
        NSLayoutConstraint.activate(cstrs)
    }
    
    @objc private func keyboardHeightDidChange(_ sender: NSNotification) {
        guard let backgroundBottomConstraint = backgroundBottomConstraint else {
            return
        }
        var delta: CGFloat = 0
        switch sender.name {
        case NSNotification.Name.UIKeyboardWillShow:
            if let info = sender.userInfo, let sz = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
                delta = -sz.height
            }
        case NSNotification.Name.UIKeyboardWillHide:
            delta = 0
        default:
            break
        }
        backgroundBottomConstraint.constant = delta
    }
    
    //MARK: public interface
    public func addAction(_ action: AlertAction) {
        actions.append(action)
        bodyView.addAction(action)
    }
    
    public func showOn(targetView: UIView) {
        targetView.addSubview(self)
        let ratio = 320 / bodyView.intrinsicContentSize.width
        self.alpha = 0.0
        bodyView.alpha = 0.0
        bodyView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
        UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            self.alpha = 1.0
            self.bodyView.alpha = 1.0
            self.bodyView.transform = .identity
            }, completion: nil)
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    //MARK: <AlertBodyViewDelegate>
    internal func bodyView(_ bodyView: AlertBodyView, didSelectedItemAtIndex index: Int) {
        actions[index].handler?()
    }
    
}
