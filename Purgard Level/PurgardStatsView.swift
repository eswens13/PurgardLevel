//
//  PurgardStatsView.swift
//  Purgard Level
//
//  Created by Erik Swenson on 7/11/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import UIKit

class PurgardStatsView: UIView {
    
    // The labels that show the status.
    var deviceNameLabel: UILabel?
    var connectionStatusLabel: UILabel?
    var levelLabel: UILabel?
    var batteryLabel: UILabel?
    var temperatureLabel: UILabel?
    
    // The dimensions of each label
    var labelHeight: CGFloat = 0.0
    var labelWidth: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.labelHeight = frame.height / 5.0
        self.labelWidth = frame.width
        print("Label height: \(self.labelHeight)")
        print("Label width: \(self.labelWidth)")
        
        let deviceNameRect = CGRect(x: 0,
                                    y: 0,
                                    width: self.labelWidth,
                                    height: self.labelHeight)
        let connectionStatusRect = CGRect(x: 0,
                                          y: self.labelHeight,
                                          width: self.labelWidth,
                                          height: self.labelHeight)
        let levelRect = CGRect(x: 0,
                                y: 2 * self.labelHeight,
                                width: self.labelWidth,
                                height: self.labelHeight)
        let batteryRect = CGRect(x: 0,
                                  y: 3 * self.labelHeight,
                                  width: self.labelWidth,
                                  height: self.labelHeight)
        let temperatureRect = CGRect(x: 0,
                                     y: 4 * self.labelHeight,
                                     width: self.labelWidth,
                                     height: self.labelHeight)
        
        self.deviceNameLabel?.translatesAutoresizingMaskIntoConstraints = true
        self.deviceNameLabel = UILabel(frame: deviceNameRect)
        self.deviceNameLabel?.font =
            UIFont(name: "HelveticaNeue", size: CGFloat(20))
        self.deviceNameLabel?.textAlignment = .Center
        self.deviceNameLabel?.textColor = UIColor.blackColor()
        
        self.connectionStatusLabel?
            .translatesAutoresizingMaskIntoConstraints = true
        self.connectionStatusLabel = UILabel(frame: connectionStatusRect)
        self.connectionStatusLabel?.font =
            UIFont(name: "HelveticaNeue", size: CGFloat(20))
        self.connectionStatusLabel?.textAlignment = .Center
        self.connectionStatusLabel?.textColor = UIColor.blackColor()
        
        self.levelLabel?.translatesAutoresizingMaskIntoConstraints = true
        self.levelLabel = UILabel(frame: levelRect)
        self.levelLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
        self.levelLabel?.textAlignment = .Center
        self.levelLabel?.textColor = UIColor.blackColor()
        
        self.batteryLabel?.translatesAutoresizingMaskIntoConstraints = true
        self.batteryLabel = UILabel(frame: batteryRect)
        self.batteryLabel?.font =
            UIFont(name: "HelveticaNeue", size: CGFloat(20))
        self.batteryLabel?.textAlignment = .Center
        self.batteryLabel?.textColor = UIColor.blackColor()
        
        self.temperatureLabel?.translatesAutoresizingMaskIntoConstraints = true
        self.temperatureLabel = UILabel(frame: temperatureRect)
        self.temperatureLabel?.font =
            UIFont(name: "HelveticaNeue", size: CGFloat(20))
        self.temperatureLabel?.textAlignment = .Center
        self.temperatureLabel?.textColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        // Remove old subviews
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        self.layoutRectangles(rect)
    }
    
    func layoutRectangles(rect: CGRect) {
        let width = rect.width
        let height = rect.height / 5.0
        let deviceNameRect = CGRect(x: 0,
                                    y: 0,
                                    width: width,
                                    height: height)
        let connectionStatusRect = CGRect(x: 0,
                                          y: height,
                                          width: width,
                                          height: height)
        let levelRect = CGRect(x: 0,
                               y: 2.0 * height,
                               width: width,
                               height: height)
        let batteryRect = CGRect(x: 0,
                                 y: 3.0 * height,
                                 width: width,
                                 height: height)
        let temperatureRect = CGRect(x: 0,
                                     y: 4.0 * height,
                                     width: width,
                                     height: height)
        self.deviceNameLabel?.frame = deviceNameRect
        self.connectionStatusLabel?.frame = connectionStatusRect
        self.levelLabel?.frame = levelRect
        self.batteryLabel?.frame = batteryRect
        self.temperatureLabel?.frame = temperatureRect
        
        self.addSubview(self.deviceNameLabel!)
        self.addSubview(self.connectionStatusLabel!)
        self.addSubview(self.levelLabel!)
        self.addSubview(self.batteryLabel!)
        self.addSubview(self.temperatureLabel!)
    }
    
    func setDeviceName(new_name: String) {
        self.deviceNameLabel?.text = new_name
        self.setNeedsDisplay()
    }
    
    func setConnectionStatus(status: String) {
        self.connectionStatusLabel?.text = status
        self.setNeedsDisplay()
    }
    
    func setLevel(new_level: String) {
        self.levelLabel?.text = new_level
        self.setNeedsDisplay()
    }
    
    func setVoltage(new_voltage: String) {
        self.batteryLabel?.text = new_voltage
        self.setNeedsDisplay()
    }
    
    func setTemperature(new_temp: String) {
        self.temperatureLabel?.text = new_temp
        self.setNeedsDisplay()
    }

}
