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
    
    func showDialog() {
        let dialog = AlertView(title: "Hello!", message: "Message here kldjfkdjalfjdaljfldksajfldjalfjdl;ajfldjalfjdlsa.")
        let action1 = AlertAction(title: "OK", style: .Default) { () -> Void in
            print("OK is pressed.");
        }
        let action2 = AlertAction(title: "Cancel", style: .Cancel) { () -> Void in
            dialog.dismiss()
        }
        dialog.addAction(action1)
        dialog.addAction(action2)
        dialog.showOn(self.view)
    }
    
    func showSystemDialog() {
        let dialog = UIAlertController(title: "Hello!", message: "Message here.", preferredStyle: .Alert)
        let action1 = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
            
        }
        dialog.addAction(action1)
        dialog.addAction(action2)
        self.presentViewController(dialog, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        showDialog()
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
