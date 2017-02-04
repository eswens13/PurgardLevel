//
//  PListWriter.swift
//  Purgard Level
//
//  Created by Erik Swenson on 2/3/17.
//  Copyright © 2017 ErikSwenson. All rights reserved.
//

import Foundation

class PListWriter {

  static func copyDevicesToDocsDir() -> Bool
  {
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                      .userDomainMask, true)[0]
                                                      as String
    let devicesPath = (docsDir as NSString).strings(
                                            byAppendingPaths: ["Devices.plist"])
    return false
  }
  
  static func addDevice(withUUID:String) -> Bool
  {
    // See the answer to this post: 
    //  http://stackoverflow.com/questions/24692746/write-to-plist-file-in-swift
    return false
  }
}
