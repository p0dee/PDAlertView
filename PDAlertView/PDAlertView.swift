//
//  PDAlertView.swift
//  PDAlertView
//
//  Created by Takeshi Tanaka on 12/17/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import UIKit

class PDAlertView: UIView {
    private let backgroundView = PDAlertBackgroundView()
    private let bodyView: PDAlertBodyView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String?, message: String?) {
        self.init()
    }
    
    
    
}

class PDAlertAction: NSObject {
    typealias Handler = () -> Void
    private var handler: Handler?
    private var title: String?
    
    override init() {
        super.init()
    }
    
    convenience init(title: String, handler: (() -> Void)?) {
        self.init()
        self.title = title
        self.handler = handler
    }
}

private class PDAlertBackgroundView : UIView {
    
}

private class PDAlertBodyView : UIView {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private var buttonTitles = [String]()
    private var actions = [PDAlertAction]()
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
    func addAction(action: PDAlertAction) {
        guard self.superview == nil else {
            assert(false, "must not add an action after adding body view to its superview.")
            return
        }
        actions.append(action)
    }

}
