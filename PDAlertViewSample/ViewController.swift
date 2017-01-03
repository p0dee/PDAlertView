//
//  ViewController.swift
//  PDAlertViewSample
//
//  Created by Takeshi Tanaka on 12/26/15.
//  Copyright © 2015 p0dee. All rights reserved.
//

import UIKit
import PDAlertView

class ViewController: UIViewController {
    
    override func loadView() {
        self.view = RainbowView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let dialog = AlertView(title: "Hello!", message: "Message here.")
        let action1 = AlertAction(title: "OK", style: .Default) { () -> Void in
            print("OK is pressed.");
        }
        let action2 = AlertAction(title: "Cancel", style: .Cancel) { () -> Void in
            dialog.dismiss()
        }
        dialog.addAction(action1)
        dialog.addAction(action2)
//        dialog.show()
        self.view.addSubview(dialog);
    }

}

class RainbowView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let numOfLines: Int32 = 15
        let scale = UIScreen.main.scale
        let width = round(rect.size.width * scale / CGFloat(numOfLines)) / scale
        for i in 0..<numOfLines {
            let posX = width * CGFloat(i)
            let fillColor = UIColor(hue: CGFloat(i) / CGFloat(numOfLines), saturation: 0.75, brightness: 1.0, alpha: 1.0)
            fillColor.setFill()
            context.fill(CGRect(x: posX, y: 0, width: width, height: rect.size.height))
        }
    }
    
}
