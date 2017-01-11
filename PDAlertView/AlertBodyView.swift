//
//  BodyView.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/23/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import UIKit

internal func actionButtonLineWidth() -> Double {
    let scale = Double(UIScreen.main.scale)
    return (scale > 2.0 ? 2.0 : 1.0) / scale
}

fileprivate extension AlertSelectionControl {
    
    fileprivate var selectedView: AlertSelectionComponentView? {
        if let selIdx = self.selectedIndex, selIdx < self.components.count {
            return self.components[selIdx]
        } else {
            return nil
        }
    
    }
}

internal protocol AlertBodyViewDelegate: class {
    func bodyView(_ bodyView: AlertBodyView, didSelectedItemAtIndex index: Int)
}

internal class AlertBodyView: UIView {
    private let vibracyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
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
    
    internal override var intrinsicContentSize: CGSize {
        return CGSize(width: 270, height: UIViewNoIntrinsicMetric)
    }
    
    internal override func willMove(toSuperview newSuperview: UIView?) {
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bodyMaskView?.sizeToFit()
    }
    
    //MARK:
    func addAction(_ action: AlertAction) {
        selectionView.addButton(with: action.title, style: action.style)
        bodyMaskView?.setNeedsDisplay()
    }
    
    //MARK:
    private func setupViews() {
        vibracyView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(vibracyView)
        let mask = UIView(frame: vibracyView.bounds)
        mask.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mask.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vibracyView.contentView.addSubview(mask)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        self.addSubview(bgView)
        bgView.mask = bodyMaskView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMargins = UIEdgeInsetsMake(20, 18, 12, 18)
        contentView.axis = .vertical
        contentView.spacing = 8.0
        self.addSubview(contentView)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        contentView.addArrangedSubview(titleLabel)
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        messageLabel.textAlignment = .center
        messageLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        contentView.addArrangedSubview(messageLabel)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.addTarget(bodyMaskView, action: "selectionViewDidChange:", for: .valueChanged)
        selectionView.addTarget(self, action: "selectionViewDidTouchUpInside:", for: .touchUpInside)
        self.addSubview(selectionView)
    }
    
    private func setupConstraints() {
        var cstrs = [NSLayoutConstraint]()
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(vibracyView)
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(blurView)
        cstrs += NSLayoutConstraint.constraintsToFillSuperview(bgView)
        let lineWidth = NSNumber(value: actionButtonLineWidth())
        let metrics = ["lineWidth" : lineWidth]
        let views = ["contentView" : contentView, "selectionView" : selectionView]
        let formatHorizG = "H:|[contentView]|"
        cstrs += NSLayoutConstraint.constraints(withVisualFormat: formatHorizG, options: .directionLeadingToTrailing, metrics: metrics, views: views)
        let formatVertG = "V:|-(20)-[contentView]-(20)-[selectionView]|"
        cstrs += NSLayoutConstraint.constraints(withVisualFormat: formatVertG, options: [.alignAllLeading, .alignAllTrailing], metrics: metrics, views: views)
        NSLayoutConstraint.activate(cstrs)
    }
    
    @objc private func selectionViewDidTouchUpInside(sender: AlertSelectionControl) {
        if let selIdx = selectionView.selectedIndex {
            delegate?.bodyView(self, didSelectedItemAtIndex: selIdx)
        }
    }
    
    private class AccessoryContentView: UIView {
        
        override func addSubview(_ view: UIView) {
            super.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = true
            view.autoresizingMask = [view.autoresizingMask, .flexibleLeftMargin, .flexibleRightMargin]
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            for v in self.subviews {
                var frame = v.frame
                frame.size.width = min(self.bounds.size.width, frame.size.width)
                frame.origin.x = (self.bounds.size.width - frame.size.width) * 0.5
                frame.origin.y = 0
                v.frame = frame
            }
        }
        
        override var intrinsicContentSize: CGSize {
            var maxY: CGFloat = 0
            for v in subviews {
                maxY = max(maxY, v.frame.maxY)
            }
            return CGSize(width: UIViewNoIntrinsicMetric, height: maxY)
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
            self.backgroundColor = UIColor.clear
            self.bodyView = bodyView
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            guard let bodyView = bodyView else {
                return size
            }
            return bodyView.bounds.size
        }
        
        override func draw(_ rect: CGRect) {
            guard let bodyView = bodyView else {
                return
            }
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.addRect(bodyView.contentView.frame.insetBy(dx: 0, dy: -20)) //FIXME:
            for view in bodyView.selectionView.components {
                if view.isEqual(bodyView.selectionView.selectedView) {
                    continue
                }
                context.addRect(CGRect(x: view.frame.origin.x + bodyView.selectionView.frame.origin.x, y: view.frame.origin.y + bodyView.selectionView.frame.origin.y + MaskView.PixelWidth, width: view.frame.size.width, height: view.frame.size.height))
            }
            UIColor.black.setFill()
            context.fillPath()
            if let view = bodyView.selectionView.selectedView {
                let rect = CGRect(x: view.frame.origin.x + bodyView.selectionView.frame.origin.x, y: view.frame.origin.y + bodyView.selectionView.frame.origin.y + MaskView.PixelWidth, width: view.frame.size.width, height: view.frame.size.height)
                if bodyView.selectionView.axis == .horizontal {
                    context.addRect(rect.insetBy(dx: -MaskView.PixelWidth, dy: 0))
                } else {
                    context.addRect(rect.insetBy(dx: 0, dy: -MaskView.PixelWidth))
                }
                UIColor.black.withAlphaComponent(0.5).setFill()
                context.fillPath()
            }
        }
        
        @objc func selectionViewDidChange(sender: AlertSelectionControl) {
            setNeedsDisplay()
        }
        
    }
    
}
