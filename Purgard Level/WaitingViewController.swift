//
//  WaitingViewController.swift
//  Purgard Level
//
//  Created by Erik Swenson on 2/17/17.
//  Copyright © 2017 ErikSwenson. All rights reserved.
//

import Foundation
import UIKit

class WaitingViewController: UIViewController
{
  var boxView:UIView?
  var activityIndicatorView: UIActivityIndicatorView?
  var label: UILabel?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // Make the background of the view somewhat see-through.
    let translucent:UIColor = UIColor(red: 0.0, green: 0.0,
                                      blue: 0.0, alpha: 0.5)
    self.view.backgroundColor = translucent
    
    // Add a box for the activity indicator.
    let center:CGPoint = CGPoint(x: self.view.frame.width / 2.0,
                                 y: self.view.frame.height / 2.0)
    let boxRect:CGRect = CGRect(x: center.x - 150, y: center.y - 100,
                                width: 300, height: 200)
    self.boxView = UIView(frame: boxRect)
    self.boxView?.backgroundColor = UIColor.white
    
    // Add the activity indicator itself to the background box.
    self.activityIndicatorView = UIActivityIndicatorView(
                                    activityIndicatorStyle: .whiteLarge)
    self.activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
    self.activityIndicatorView?.startAnimating()
    self.boxView?.addSubview(self.activityIndicatorView!)
    
    // Add the activity indicator to the main view.
    self.view.addSubview(self.boxView!)
  }
  
  func didFinishWaiting()
  {
    self.dismiss(animated: true, completion: nil)
  }
}
