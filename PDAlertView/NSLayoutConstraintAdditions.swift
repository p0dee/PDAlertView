//
//  NSLayoutConstraintAdditions.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/23/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    class func constraintsToFillSuperview(targetView: UIView) -> [NSLayoutConstraint] {
        guard let superview = targetView.superview else {
            assert(false, "targetView must have its superview.")
            return []
        }
        var cstrs = [NSLayoutConstraint]()
        cstrs.append(targetView.leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor))
        cstrs.append(targetView.topAnchor.constraintEqualToAnchor(superview.topAnchor))
        cstrs.append(targetView.trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor))
        cstrs.append(targetView.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor))
        return cstrs
    }
    
    class func constraintsToFillSuperviewMarginsGuide(targetView: UIView) -> [NSLayoutConstraint] {
        // 以下じゃダメ。なぜ？？
        //        guard let margin = targetView.superview?.layoutMarginsGuide else {
        //            assert(false, "targetView must have its superview.")
        //            return []
        //        }
        //        var cstrs = [NSLayoutConstraint]()
        //        print("margin: \(margin)")
        //        cstrs.append(targetView.leadingAnchor.constraintEqualToAnchor(margin.leadingAnchor))
        //        cstrs.append(targetView.topAnchor.constraintEqualToAnchor(margin.topAnchor))
        //        cstrs.append(targetView.trailingAnchor.constraintEqualToAnchor(margin.trailingAnchor))
        //        cstrs.append(targetView.bottomAnchor.constraintEqualToAnchor(margin.bottomAnchor))
        guard targetView.superview != nil else {
            assert(false, "targetView must have its superview.")
            return []
        }
        let views = ["view" : targetView]
        let formatHoriz = "H:|-[view]-|"
        let formatVert = "V:|-[view]-|"
        var cstrs = [NSLayoutConstraint]()
        cstrs += NSLayoutConstraint.constraintsWithVisualFormat(formatHoriz, options: .DirectionLeadingToTrailing, metrics: nil, views: views)
        cstrs += NSLayoutConstraint.constraintsWithVisualFormat(formatVert, options: .DirectionLeadingToTrailing, metrics: nil, views: views)
        return cstrs
    }
    
}
