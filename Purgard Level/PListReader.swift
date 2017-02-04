//
//  PListReader.swift
//  Purgard Level
//
//  Created by Erik Swenson on 2/3/17.
//  Copyright © 2017 ErikSwenson. All rights reserved.
//

import Foundation

class PListReader {
  
  static func readDevices() -> [String]
  {
    var deviceUUIDs:[String] = []
    
    if let fileUrl = Bundle.main.url(forResource: "Devices",
                                     withExtension: "plist"),
      let plistData = try? Data(contentsOf: fileUrl)
    {
      if let result = try? PropertyListSerialization.propertyList(
        from: plistData, options: [], format: nil) as? [String:Any]
      {
        deviceUUIDs = result!["Devices"] as! [String]
      }
    }
    
    return deviceUUIDs
  }
  
}
