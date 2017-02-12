//
//  ViewController.swift
//  Purgard Level
//
//  Created by Erik Swenson on 3/8/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
  var bleController: BLEController?
  var levelView: PurgardLevelView!
  var batteryView: BatteryView!
  var temperatureView: TemperatureView!
  var statsView: PurgardStatsView!
  var device: CBPeripheral?
    
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.bleController?.connectToDevice(device!)
    self.setControlProperties()
  }
    
  override func viewDidLayoutSubviews()
  {
    super.viewDidLayoutSubviews()
    if self.isLandscape()
    {
      self.layoutAsLandscape()
    }
    else
    {
      self.layoutAsPortrait()
    }
  }
    
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    print("Received memory warning")
  }
    
  func isLandscape() -> Bool
  {
    if self.view.bounds.width > self.view.bounds.height
    {
        return true
    }
    else
    {
        return false
    }
  }
    
  // Lays out the views in two rows of two.
  func layoutAsPortrait()
  {
    var navbarHeight:CGFloat
    if (self.navigationController != nil)
    {
      navbarHeight = self.navigationController!.navigationBar.frame.height
    }
    else
    {
      navbarHeight = 0
    }
    let width = self.view.bounds.width
    let height = self.view.bounds.height - navbarHeight
    
    // Layout level view
    let levelRect = CGRect(x: width / 2.0,
                           y: navbarHeight,
                           width: width / 2.0,
                           height: height / 2.0)
    self.levelView.frame = levelRect
    self.levelView.layoutSubviews()
    
    // Layout battery view
    let batteryRect = CGRect(x: 0,
                             y: (height / 2.0) + navbarHeight,
                             width: width / 2.0,
                             height: height / 2.0)
    self.batteryView.frame = batteryRect
    self.batteryView.layoutSubviews()
    
    // Layout temperature view
    let tempRect = CGRect(x: width / 2.0,
                          y: (height / 2.0) + navbarHeight,
                          width: width / 2.0,
                          height: height / 2.0)
    self.temperatureView.frame = tempRect
    self.temperatureView.layoutSubviews()
    
    // Layout stats view
    let statsRect = CGRect(x: 0,
                           y: navbarHeight,
                           width: width / 2.0,
                           height: height / 2.0)
    self.statsView.frame = statsRect
    self.statsView.layoutSubviews()
  }
    
  // Lays out the views in a row of four.
  func layoutAsLandscape()
  {
    var navbarHeight: CGFloat
    if (self.navigationController != nil)
    {
      navbarHeight = self.navigationController!.navigationBar.frame.height
    }
    else
    {
      navbarHeight = 0
    }
    let width = self.view.bounds.width
    let height = self.view.bounds.height - navbarHeight
    
    // Layout stats view
    let statsRect = CGRect(x: 0,
                           y: navbarHeight,
                           width: width / 4.0,
                           height: height)
    self.statsView.frame = statsRect
    self.statsView.layoutSubviews()
    
    // Layout level view
    let levelRect = CGRect(x: width / 4.0,
                           y: navbarHeight,
                           width: width / 4.0,
                           height: height)
    self.levelView.frame = levelRect
    self.levelView.layoutSubviews()
    
    // Layout battery view
    let batteryRect = CGRect(x: 2.0 * width / 4.0,
                             y: navbarHeight,
                             width: width / 4.0,
                             height: height)
    self.batteryView.frame = batteryRect
    self.batteryView.layoutSubviews()
    
    // Layout temperature view
    let tempRect = CGRect(x: 3.0 * width / 4.0,
                          y: navbarHeight,
                          width: width / 4.0,
                          height: height)
    self.temperatureView.frame = tempRect
    self.temperatureView.layoutSubviews()
  }

  func setControlProperties()
  {
    // Get some useful information about the screen
    let centerX = self.view.center.x
    let centerY = self.view.center.y
    let screenRect = UIScreen.main.bounds
    let screenWidth = screenRect.width
    let screenHeight = screenRect.height
    
    // This line allows us to move the label where we'd like to. Basically,
    // it allows us to override AutoLayout for whatever component it is
    // called on
    //titleLabel.translatesAutoresizingMaskIntoConstraints = true
    
    let statsRect = CGRect(x: 0, y: 0, width: 200, height: 200)
    self.statsView = PurgardStatsView(frame: statsRect)
    self.statsView.translatesAutoresizingMaskIntoConstraints = true
    self.statsView.backgroundColor = UIColor.clear
    self.statsView.setDeviceName("Device: \(self.navigationItem.title!)")
    self.view.addSubview(self.statsView)
    
    let levelRect = CGRect(x: 0, y: 0, width: 200, height: 200)
    self.levelView = PurgardLevelView(frame: levelRect)
    self.levelView.translatesAutoresizingMaskIntoConstraints = true
    self.levelView.backgroundColor = UIColor.clear
    self.view.addSubview(self.levelView)

    // Set properties for progress view. Default height of the progress bar 
    // is 2.0 so we scale accordingly
    /*progressView.translatesAutoresizingMaskIntoConstraints = true
    let navBarHeight = self.navigationController?.navigationBar.frame.height
    let progressViewRect = CGRect(x: 0,
                                  y: 0,
                                  width: (2.0 * screenHeight / 3.0)
                                                                - navBarHeight!,
                                  height: screenWidth / 2.0)
    progressView.frame = progressViewRect.insetBy(dx: 20, dy: 0)
    progressView.center = CGPointMake(screenWidth / 2.0, 
                                      (screenHeight / 3.0) + navBarHeight!)
    progressView.progressTintColor = UIColor(red: 0.0,
                                             green: (134.0 / 255.0),
                                             blue: (139.0 / 255.0),
                                             alpha: 1.0)
    progressView.setProgress(0.0, animated: false)
    progressView.transform =
          CGAffineTransformMakeRotation(CGFloat(3.0 * M_PI / 2.0))
    progressView.transform =
          CGAffineTransformScale(progressView.transform, 1.0, screenWidth / 3.0)
     */
    
    // Add the battery view
    let battRect = CGRect(x:0,
                          y:0,
                          width: screenHeight / 6.0,
                          height: screenHeight / 3.0)
    self.batteryView = BatteryView(frame: battRect.insetBy(dx: 0, dy: 20))
    self.batteryView.translatesAutoresizingMaskIntoConstraints = true
    self.batteryView.backgroundColor = UIColor.clear
    self.batteryView.updateLevel(0)
    self.view.addSubview(self.batteryView)
    
    // Add the temperature view
    let tempRect = CGRect(x: 0,
                          y: 0,
                          width: screenHeight / 6.0,
                          height: screenHeight / 3.0)
    self.temperatureView =
                        TemperatureView(frame: tempRect.insetBy(dx: 20, dy: 20))
    self.temperatureView.translatesAutoresizingMaskIntoConstraints = true
    self.temperatureView.backgroundColor = UIColor.clear
    self.temperatureView.updateLevel(0)
    self.view.addSubview(self.temperatureView)
    
    self.view.layoutSubviews()
  }
    
  /// TESTING METHOD
  func drawCirclesAtCorners(_ rect: CGRect, color: UIColor)
  {
    var corners = [CGPoint]()
    let origin = rect.origin
    let width = rect.width
    let height = rect.height
    let tRPoint = CGPoint(x: origin.x + width, y: origin.y)
    let bRPoint = CGPoint(x: origin.x + width, y: origin.y + height)
    let blPoint = CGPoint(x: origin.x, y: origin.y + height)
    corners.append(origin)
    corners.append(tRPoint)
    corners.append(bRPoint)
    corners.append(blPoint)
    
    for corner in corners
    {
      let circlePath = UIBezierPath(arcCenter: corner, radius: 5.0,
          startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: false)
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = circlePath.cgPath
      
      shapeLayer.fillColor = color.cgColor
      shapeLayer.strokeColor = color.cgColor
      shapeLayer.lineWidth = 2.0
      
      view.layer.addSublayer(shapeLayer)
    }
  }
    
  /// Function to update the level.
  func updateProgress(_ progress: Int)
  {
    if (progress > 100)
    {
      self.levelView.updateProgress(100)
      self.statsView.setLevel("Level: 100 %")
    }
    else
    {
      self.levelView.updateProgress(progress)
      self.statsView.setLevel("Level: \(progress) %")
    }
  }

  /// Function to update the voltage.
  func updateVoltage(_ voltage: Int)
  {
    if (voltage > 100)
    {
      self.batteryView.updateLevel(100)
      self.statsView.setVoltage("Batt: 100 %")
    }
    else
    {
      self.batteryView.updateLevel(voltage)
      self.statsView.setVoltage("Batt: \(voltage) %")
    }
  }
    
  /// Function to update the temperature.
  func updateTemperature(_ temperature: Int)
  {
    self.temperatureView.updateLevel(CGFloat(temperature))
    let fahrTemp = ((9.0 / 5.0) * Double(temperature)) + 32.0
    self.statsView.setTemperature("Temp: \(Int(fahrTemp)) \u{00B0}F")
  }
    
  override func willMove(toParentViewController parent: UIViewController?)
  {
    if parent == nil && bleController?.currentDevice != nil
    {
      bleController!.disconnectFromCurrentDevice()
    }
  }
    

}

