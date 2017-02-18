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
  
  var bleController: BLEController?
  var deviceListVC: DeviceListTableViewController?
  
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
    self.boxView?.layer.cornerRadius = 10
    
    // Add the activity indicator itself to the background box.
    self.activityIndicatorView = UIActivityIndicatorView(
                                    activityIndicatorStyle: .gray)
    self.activityIndicatorView?.frame =
                                    CGRect(x: 0, y: 0, width: 300, height: 200)
    self.activityIndicatorView?.startAnimating()
    self.boxView?.addSubview(self.activityIndicatorView!)
    
    // Add the label to the background box.
    self.label = UILabel(frame: CGRect(x: 0, y: 140, width: 300, height: 30))
    self.label?.textAlignment = .center
    self.label?.font = UIFont(name: (self.label?.font.fontName)!, size: 20)
    self.label?.text = "Connecting . . ."
    self.boxView?.addSubview(self.label!)
    
    // Add the activity indicator to the main view.
    self.view.addSubview(self.boxView!)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.waitForConnection()
  }
  
  func setBLEController(controller: BLEController)
  {
    self.bleController = controller
  }
  
  func setDeviceListVC(controller: DeviceListTableViewController)
  {
    self.deviceListVC = controller
  }
  
  func waitForConnection()
  {
    self.bleController?.batterySem.wait()
    self.bleController?.tempSem.wait()
    self.bleController?.levelSem.wait()
    
    self.deviceListVC?.cameFromWait = true
    
    self.dismiss(animated: true, completion: nil)
  }
}
