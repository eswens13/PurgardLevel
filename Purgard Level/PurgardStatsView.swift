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
    @IBOutlet var deviceNameLabel: UILabel?
    @IBOutlet var connectionStatusLabel: UILabel?
    @IBOutlet var levelLabel: UILabel?
    @IBOutlet var batteryLabel: UILabel?
    @IBOutlet var temperatureLabel: UILabel?
    
    // The dimensions of each label
    var labelHeight: CGFloat = 0.0
    var labelWidth: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.labelHeight = frame.height / 5
        self.labelWidth = frame.width
        
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
        
        self.deviceNameLabel = UILabel(frame: deviceNameRect)
        self.deviceNameLabel?.textAlignment = .Center
        self.connectionStatusLabel = UILabel(frame: connectionStatusRect)
        self.connectionStatusLabel?.textAlignment = .Center
        self.levelLabel = UILabel(frame: levelRect)
        self.levelLabel?.textAlignment = .Center
        self.batteryLabel = UILabel(frame: batteryRect)
        self.batteryLabel?.textAlignment = .Center
        self.temperatureLabel = UILabel(frame: temperatureRect)
        self.temperatureLabel?.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        self.layoutRectangles()
    }
    
    func layoutRectangles() {
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
        self.deviceNameLabel?.frame = deviceNameRect
        self.connectionStatusLabel?.frame = connectionStatusRect
        self.levelLabel?.frame = levelRect
        self.batteryLabel?.frame = batteryRect
        self.temperatureLabel?.frame = temperatureRect
    }
    
    func setDeviceName(new_name: String) {
        self.deviceNameLabel?.text = new_name
    }
    
    func setConnectionStatus(status: String) {
        self.connectionStatusLabel?.text = status
    }
    
    func setLevel(new_level: String) {
        self.levelLabel?.text = new_level
    }
    
    func setVoltage(new_voltage: String) {
        self.batteryLabel?.text = new_voltage
    }
    
    func setTemperature(new_temp: String) {
        self.temperatureLabel?.text = new_temp
    }

}
