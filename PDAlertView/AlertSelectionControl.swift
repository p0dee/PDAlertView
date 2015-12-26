//
//  AlertSelectionControl.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/23/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import UIKit

internal class AlertSelectionControl: UIControl {
    
    private let stackView = UIStackView()
    internal var components = [AlertSelectionComponentView]()
    
    internal var axis: UILayoutConstraintAxis {
        return stackView.axis
    }
    
    var selectedIndex: Int? {
        didSet {
            if (selectedIndex != oldValue) {
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            selectedIndex = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        stackView.distribution = .FillEqually
        stackView.spacing = 1.0 / UIScreen.mainScreen().scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        let cstrs = NSLayoutConstraint.constraintsToFillSuperview(stackView)
        NSLayoutConstraint.activateConstraints(cstrs)
    }
    
    func addButtonWithTitle(title: String, style: AlertActionStyle) {
        let component = AlertSelectionComponentView(title: title, style: style)
        component.userInteractionEnabled = false
        stackView.addArrangedSubview(component)
        components.append(component)
        if stackView.axis == .Vertical {
            //Do nothing.
        } else if components.count > 2 || component.preferredLayoutAxis == .Vertical {
            stackView.axis = .Vertical
        }
    }
    
    private func selectedIndexWithPoint(point: CGPoint) -> Int? {
        for view in stackView.arrangedSubviews {
            if let view = view as? AlertSelectionComponentView where CGRectContainsPoint(view.frame, point) {
                return components.indexOf(view)
            }
        }
        return nil
    }
    
    //MARK: override
    internal override func tintColorDidChange() {
        for comp in components {
            switch comp.style {
            case .Default:
                comp.tintColor = tintColor
            default:
                break
            }
        }
    }
    
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self)
            selectedIndex = selectedIndexWithPoint(point)
        }
    }
    
    internal override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self)
            selectedIndex = selectedIndexWithPoint(point)
        }
    }
    
    internal override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self)
            if CGRectContainsPoint(self.bounds, point) {
                sendActionsForControlEvents(.TouchUpInside)
            }
        }
        selectedIndex = nil
    }
    
}

internal class AlertSelectionComponentView: UIView {
    
    private var label = UILabel()
    private var style: AlertActionStyle = .Default
    
    private var preferredLayoutAxis: UILayoutConstraintAxis {
        guard let text = label.text else {
            return .Vertical
        }
        let attrs = [NSFontAttributeName : label.font]
        let size = NSString(string: text).sizeWithAttributes(attrs)
        return size.width > 115 ? .Vertical : .Horizontal
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, style: AlertActionStyle) {
        self.init()
        self.style = style
        if style == .Destructive {
            self.tintColor = UIColor(red: 255/255.0, green: 0, blue: 33/255.0, alpha: 1.0)
        }
        label.text = title
        switch style {
        case .Cancel:
            label.font = UIFont.boldSystemFontOfSize(17.0)
        default:
            label.font = UIFont.systemFontOfSize(17.0)
        }
    }
    
    private func setupViews() {
        self.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = tintColor
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.lineBreakMode = .ByTruncatingMiddle
        label.baselineAdjustment = .AlignCenters
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        self.addSubview(label)
    }
    
    private func setupConstraints() {
        let cstrs = NSLayoutConstraint.constraintsToFillSuperviewMarginsGuide(label)
        NSLayoutConstraint.activateConstraints(cstrs)
    }
    
    //MARK: override
    internal override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 44)
    }
    
    internal override func tintColorDidChange() {
        label.textColor = tintColor
    }
    
}
