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
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    
    var bleController: BLEController?
    var batteryView: BatteryView!
    var temperatureView: TemperatureView!
    var device: CBPeripheral?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.bleController?.connectToDevice(device!)
        self.setControlProperties()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isLandscape() {
            // Layout in a row of four
        }
        else {
            // Layout in two rows of two
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isLandscape() -> Bool {
        if self.view.bounds.width > self.view.bounds.height {
            return true
        }
        else {
            return false
        }
    }

    func setControlProperties() {
        
        // Get some useful information about the screen
        let centerX = self.view.center.x
        let centerY = self.view.center.y
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.width
        let screenHeight = screenRect.height
        
        // This line allows us to move the label where we'd like to. Basically,
        // it allows us to override AutoLayout for whatever component it is
        // called on
        //titleLabel.translatesAutoresizingMaskIntoConstraints = true
 
        // Set properties for progress view. Default height of the progress bar 
        // is 2.0 so we scale accordingly
        progressView.translatesAutoresizingMaskIntoConstraints = true
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        let progressViewRect = CGRect(x: 0, y: 0,
                                      width: (2.0 * screenHeight / 3.0) - navBarHeight!,
                                      height: screenWidth / 2.0)
        progressView.frame = progressViewRect.insetBy(dx: 20, dy: 0)
        progressView.center = CGPointMake(screenWidth / 2.0, (screenHeight / 3.0) + navBarHeight!)
        progressView.progressTintColor = UIColor(red: 0.0, green: (134.0 / 255.0),
            blue: (139.0 / 255.0), alpha: 1.0)
        progressView.setProgress(0.0, animated: false)
        progressView.transform = CGAffineTransformMakeRotation(CGFloat(3.0 * M_PI / 2.0))
        progressView.transform = CGAffineTransformScale(progressView.transform,
            1.0, screenWidth / 3.0)
        
        // Set level label
        levelLabel.translatesAutoresizingMaskIntoConstraints = true
        levelLabel.font = levelLabel.font.fontWithSize(24)
        levelLabel.center = CGPointMake(screenWidth / 2.0, screenHeight / 3.0)
        
        // Set connection label
        connectionLabel.translatesAutoresizingMaskIntoConstraints = true
        connectionLabel.center = CGPointMake(centerX, screenHeight - 20)
        
        // Add the battery view
        let battRect = CGRect(x:0, y:0,
                          width: screenHeight / 6.0,
                          height: screenHeight / 3.0)
        self.batteryView = BatteryView(frame: battRect.insetBy(dx: 0, dy: 20))
        self.batteryView.translatesAutoresizingMaskIntoConstraints = true
        self.batteryView.center = CGPointMake(screenWidth / 3.0, 5.0 * screenHeight / 6.0)
        self.batteryView.backgroundColor = UIColor.clearColor()
        self.batteryView.updateLevel(0.0)
        self.view.addSubview(self.batteryView)
        
        // Add the temperature view
        let tempRect = CGRect(x: 0, y: 0,
                              width: screenHeight / 6.0,
                              height: screenHeight / 3.0)
        self.temperatureView = TemperatureView(frame: tempRect.insetBy(dx: 20, dy: 20))
        self.temperatureView.translatesAutoresizingMaskIntoConstraints = true
        self.temperatureView.center = CGPointMake(2.0 * screenWidth / 3.0, 5.0 * screenHeight / 6.0)
        self.temperatureView.backgroundColor = UIColor.clearColor()
        self.temperatureView.updateLevel(0)
        self.view.addSubview(self.temperatureView)
        
    }
    
    /// TESTING METHOD
    func drawCirclesAtCorners(rect: CGRect, color: UIColor) {
        var corners = [CGPoint]()
        let origin = rect.origin
        let width = rect.width
        let height = rect.height
        let tRPoint = CGPointMake(origin.x + width, origin.y)
        let bRPoint = CGPointMake(origin.x + width, origin.y + height)
        let blPoint = CGPointMake(origin.x, origin.y + height)
        corners.append(origin)
        corners.append(tRPoint)
        corners.append(bRPoint)
        corners.append(blPoint)
        
        for corner in corners {
            let circlePath = UIBezierPath(arcCenter: corner, radius: 5.0,
                startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: false)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.CGPath
            
            shapeLayer.fillColor = color.CGColor
            shapeLayer.strokeColor = color.CGColor
            shapeLayer.lineWidth = 2.0
            
            view.layer.addSublayer(shapeLayer)
        }

    }
    
    func updateProgress(progress: Int) {
        let myFloat:Float = Float(progress) / 100.0
        progressView.setProgress(myFloat, animated: true)
        levelLabel.text = "\(progress)%"
    }
    
    func updateVoltage(voltage: Int) {
        let volts = Float(voltage)
        let voltProgress = Float(volts / 100.0)
        self.batteryView.updateLevel(CGFloat(voltProgress))
        //voltageLabel.text = "Voltage:  \(volts) V"
    }
    
    func updateTemperature(temperature: Int) {
        self.temperatureView.updateLevel(CGFloat(temperature))
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil && bleController?.currentDevice != nil {
            bleController!.disconnectFromCurrentDevice()
        }
    }
    

}

