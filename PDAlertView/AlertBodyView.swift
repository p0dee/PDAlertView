//
//  BodyView.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/23/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import UIKit

internal func actionButtonLineWidth() -> Double {
    let scale = Double(UIScreen.mainScreen().scale)
    return (scale > 2.0 ? 2.0 : 1.0) / scale
}

private extension AlertSelectionControl {
    
    private var selectedView: AlertSelectionComponentView? {
        if let selIdx = self.selectedIndex where selIdx < self.components.count {
            return self.components[selIdx]
        } else {
            return nil
        }
    }
    
}

internal protocol AlertBodyViewDelegate: class {
    func bodyView(bodyView: AlertBodyView, didSelectedItemAtIndex index: Int)
}

internal class AlertBodyView: UIView {
    private let vibracyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Dark)))
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    private let bgView = UIView()
    private var bodyMaskView: MaskView?
    private let contentView = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let selectionView = AlertSelectionControl()
    let accessoryContentView = AccessoryContentView() as UIView
    var delegate: AlertBodyViewDelegate?
    
    var button = UITableViewCell()
    
    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    var message: String? {
        set {
            messageLabel.text = newValue
        }
        get {
            return messageLabel.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bodyMaskView = MaskView(bodyView: self)
        self.clipsToBounds = true
        self.layer.cornerRadius = 7.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(270, UIViewNoIntrinsicMetric)
    }
    
    internal override func willMoveToSuperview(newSuperview: UIView?) {
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bodyMaskView?.sizeToFit()
    }
    
    //MARK:
    func addAction(action: AlertAction) {
        selectionView.addButtonWithTitle(action.title, style: action.style)
        bodyMaskView?.setNeedsDisplay()
    }
    
    //MARK:
    private func setupViews() {
        vibracyView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(vibracyView)
        let mask = UIView(frame: vibracyView.bounds)
        mask.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mask.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        vibracyView.contentView.addSubview(mask)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        self.addSubview(bgView)
        bgView.maskView = bodyMaskView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMargins = UIEdgeInsetsMake(20, 18, 12, 18)
        contentView.axis = .Vertical
        contentView.spacing = 8.0
        self.addSubview(contentView)
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.textAlignment = .Center
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        contentView.addArrangedSubview(titleLabel)
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFontOfSize(13.0)
        messageLabel.textAlignment = .Center
        messageLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        contentView.addArrangedSubview(messageLabel)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.addTarget(bodyMaskView, action: "selectionViewDidChange:", forControlEvents: .ValueChanged)
        selectionView.addTarget(self, action: "selectionViewDidTouchUpInside:", forControlEvents: .TouchUpInside)
        self.addSubview(selectionView)
    }
    
    private func setupConstraints() {
        var cstrs = [NSLayoutConstraint]()
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(vibracyView)
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(blurView)
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(bgView)
        let lineWidth = NSNumber(double: actionButtonLineWidth())
        let metrics = ["lineWidth" : lineWidth]
        let views = ["contentView" : contentView, "selectionView" : selectionView]
        let formatHorizG = "H:|[contentView]|"
        cstrs += NSLayoutConstraint.constraintsWithVisualFormat(formatHorizG, options: .DirectionLeadingToTrailing, metrics: metrics, views: views)
        let formatVertG = "V:|-(20)-[contentView]-(20)-[selectionView]|"
        cstrs += NSLayoutConstraint.constraintsWithVisualFormat(formatVertG, options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: views)
        NSLayoutConstraint.activateConstraints(cstrs)
    }
    
    @objc private func selectionViewDidTouchUpInside(sender: AlertSelectionControl) {
        if let selIdx = selectionView.selectedIndex {
            delegate?.bodyView(self, didSelectedItemAtIndex: selIdx)
        }
    }
    
    private class AccessoryContentView: UIView {
        
        private override func addSubview(view: UIView) {
            super.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = true
            view.autoresizingMask = [view.autoresizingMask, .FlexibleLeftMargin, .FlexibleRightMargin]
        }
        
        private override func layoutSubviews() {
            super.layoutSubviews()
            for v in self.subviews {
                var frame = v.frame
                frame.size.width = min(self.bounds.size.width, frame.size.width)
                frame.origin.x = (self.bounds.size.width - frame.size.width) * 0.5
                frame.origin.y = 0
                v.frame = frame
            }
        }
        
        private override func intrinsicContentSize() -> CGSize {
            var maxY: CGFloat = 0
            for v in subviews {
                maxY = max(maxY, CGRectGetMaxY(v.frame))
            }
            return CGSizeMake(UIViewNoIntrinsicMetric, maxY)
        }
        
        func hasContent() -> Bool {
            return self.subviews.count > 0
        }
        
    }
    
    private class MaskView: UIView {
        
        weak private var bodyView: AlertBodyView?
        private static let PixelWidth = CGFloat(actionButtonLineWidth())
        
        convenience init(bodyView: AlertBodyView) {
            self.init()
            self.backgroundColor = UIColor.clearColor()
            self.bodyView = bodyView
        }
        
        private override func sizeThatFits(size: CGSize) -> CGSize {
            guard let bodyView = bodyView else {
                return size
            }
            return bodyView.bounds.size
        }
        
        private override func drawRect(rect: CGRect) {
            guard let bodyView = bodyView else {
                return
            }
            
            let context = UIGraphicsGetCurrentContext()
            CGContextAddRect(context, CGRectInset(bodyView.contentView.frame, 0, -20)) //FIXME:
            for view in bodyView.selectionView.components {
                if view.isEqual(bodyView.selectionView.selectedView) {
                    continue
                }
                CGContextAddRect(context, CGRectMake(view.frame.origin.x + bodyView.selectionView.frame.origin.x, view.frame.origin.y + bodyView.selectionView.frame.origin.y + MaskView.PixelWidth, view.frame.size.width, view.frame.size.height))
            }
            UIColor.blackColor().setFill()
            CGContextFillPath(context)
            if let view = bodyView.selectionView.selectedView {
                let rect = CGRectMake(view.frame.origin.x + bodyView.selectionView.frame.origin.x, view.frame.origin.y + bodyView.selectionView.frame.origin.y + MaskView.PixelWidth, view.frame.size.width, view.frame.size.height)
                if bodyView.selectionView.axis == .Horizontal {
                    CGContextAddRect(context, CGRectInset(rect, -MaskView.PixelWidth, 0))
                } else {
                    CGContextAddRect(context, CGRectInset(rect, 0, -MaskView.PixelWidth))
                }
                UIColor.blackColor().colorWithAlphaComponent(0.5).setFill()
                CGContextFillPath(context)
            }
        }
        
        @objc func selectionViewDidChange(sender: AlertSelectionControl) {
            setNeedsDisplay()
        }
        
    }
    
}
