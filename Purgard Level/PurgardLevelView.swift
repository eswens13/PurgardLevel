//
//  PurgardLevelView.swift
//  Purgard Level
//
//  Created by Erik Swenson on 7/12/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import UIKit

class PurgardLevelView: UIView {

    var progressView: UIView?
    var backgroundView: UIView?
    var progress: Int = 0
    var progressTintColor = UIColor(red: 0.0,
                                    green: (134.0 / 255.0),
                                    blue: (139.0 / 255.0),
                                    alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundView?.translatesAutoresizingMaskIntoConstraints = true
        self.backgroundView = UIView(frame: frame.insetBy(dx: 20, dy: 20))
        self.backgroundView?.backgroundColor = UIColor.grayColor()
        
        let progressViewRect = CGRect(x: self.backgroundView!.frame.minX,
                                      y: self.backgroundView!.frame.maxY - 10,
                                      width: self.backgroundView!.frame.width,
                                      height: 10)
        self.progressView?.translatesAutoresizingMaskIntoConstraints = true
        self.progressView = UIView(frame: progressViewRect)
        self.progressView?.backgroundColor = self.progressTintColor
        
        self.addSubview(self.backgroundView!)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func drawRect(rect: CGRect) {
        
        // Remove old progress view
        self.progressView?.removeFromSuperview()
        
        self.backgroundView?.frame = rect.insetBy(dx: 20, dy: 20)
        
        let backgroundHeight = self.backgroundView!.frame.height
        let blCorner = CGPoint(x: self.backgroundView!.frame.minX,
                               y: self.backgroundView!.frame.maxY)
        let progressFraction = CGFloat(Double(self.progress) / 100.0)
        let ulCorner = CGPoint(x: self.backgroundView!.frame.minX,
                               y: self.backgroundView!.frame.maxY - (progressFraction * backgroundHeight))
        
        let progressViewRect = CGRect(x: ulCorner.x,
                                       y: ulCorner.y,
                                       width: self.backgroundView!.frame.width,
                                       height: progressFraction * backgroundHeight)
        self.progressView?.frame = progressViewRect
        
        self.addSubview(self.progressView!)
        
    }
    
    func updateProgress(new_progress: Int) {
        self.progress = new_progress
        self.setNeedsDisplay()
    }

}
