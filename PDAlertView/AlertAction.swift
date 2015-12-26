//
//  AlertAction.swift
//  AlertViewMock
//
//  Created by Takeshi Tanaka on 12/23/15.
//  Copyright © 2015 Takeshi Tanaka. All rights reserved.
//

import Foundation

internal typealias Handler = () -> Void

public enum AlertActionStyle {
    case Default
    case Cancel
    case Destructive
}

public class AlertAction {
    
    private(set) var title: String
    private(set) var style: AlertActionStyle
    private(set) var handler: Handler?
    
    public init(title: String, style: AlertActionStyle, handler: (() -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}