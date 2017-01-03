//
//  NSLayoutConstraintAdditions.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/23/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    class func constraintsToFillSuperview(_ targetView: UIView) -> [NSLayoutConstraint] {
        guard let superview = targetView.superview else {
            assert(false, "targetView must have its superview.")
            return []
        }
        var cstrs = [NSLayoutConstraint]()
        cstrs.append(targetView.leadingAnchor.constraint(equalTo: superview.leadingAnchor))
        cstrs.append(targetView.topAnchor.constraint(equalTo: superview.topAnchor))
        cstrs.append(targetView.trailingAnchor.constraint(equalTo: superview.trailingAnchor))
        cstrs.append(targetView.bottomAnchor.constraint(equalTo: superview.bottomAnchor))
        return cstrs
    }
    
    class func constraintsToFillSuperviewMarginsGuide(_ targetView: UIView) -> [NSLayoutConstraint] {
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
        cstrs += NSLayoutConstraint.constraints(withVisualFormat: formatHoriz, options: .directionLeadingToTrailing, metrics: nil, views: views)
        cstrs += NSLayoutConstraint.constraints(withVisualFormat: formatVert, options: .directionLeadingToTrailing, metrics: nil, views: views)
        return cstrs
    }
    
}
