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
                sendActions(for: .valueChanged)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            selectedIndex = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        stackView.distribution = .fillEqually
        stackView.spacing = CGFloat(actionButtonLineWidth())
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
        NSLayoutConstraint.activate(cstrs)
    }
    
    func addButton(with title: String, style: AlertActionStyle) {
        let component = AlertSelectionComponentView(title: title, style: style)
        component.isUserInteractionEnabled = false
        stackView.addArrangedSubview(component)
        components.append(component)
        if stackView.axis == .vertical {
            //Do nothing.
        } else if components.count > 2 || component.preferredLayoutAxis == .vertical {
            stackView.axis = .vertical
        }
    }
    
    private func selectedIndex(with point: CGPoint) -> Int? {
        for view in stackView.arrangedSubviews {
            if let view = view as? AlertSelectionComponentView, view.frame.contains(point) {
                return components.index(of: view)
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
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            selectedIndex = selectedIndex(with: point)
        }
    }
    
    internal override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            selectedIndex = selectedIndex(with: point)
        }
    }
    
    internal override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            if self.bounds.contains(point) {
                sendActions(for: .touchUpInside)
            }
        }
        selectedIndex = nil
    }
    
}

internal class AlertSelectionComponentView: UIView {
    
    private var label = UILabel()
    fileprivate var style: AlertActionStyle = .Default
    
    fileprivate var preferredLayoutAxis: UILayoutConstraintAxis {
        guard let text = label.text else {
            return .vertical
        }
        let attrs = [NSFontAttributeName : label.font]
        let size = NSString(string: text).size(attributes: attrs)
        return size.width > 115 ? .vertical : .horizontal
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
            label.font = UIFont.boldSystemFont(ofSize: 17.0)
        default:
            label.font = UIFont.systemFont(ofSize: 17.0)
        }
    }
    
    private func setupViews() {
        self.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = tintColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.lineBreakMode = .byTruncatingMiddle
        label.baselineAdjustment = .alignCenters
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        self.addSubview(label)
    }
    
    private func setupConstraints() {
        let cstrs = NSLayoutConstraint.constraintsToFillSuperviewMarginsGuide(label)
        NSLayoutConstraint.activate(cstrs)
    }
    
    //MARK: override
    internal override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 44)
    }
    
    internal override func tintColorDidChange() {
        label.textColor = tintColor
    }
    
}
