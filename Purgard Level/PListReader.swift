//
//  PListReader.swift
//  Purgard Level
//
//  Created by Erik Swenson on 2/3/17.
//  Copyright © 2017 ErikSwenson. All rights reserved.
//

import Foundation
/// This class is used to read data from any plist used by this application. The
/// code for this class comes in large part from the Stack Overflow post located
/// at:
///     http://stackoverflow.com/questions/24692746/write-to-plist-file-in-swift
///
class PListReader
{
  
  /// Reads the Devices plist in the Documents directory to get an array of any
  /// device UUID strings that we have connected with before.
  ///
  /// @return An array of the device UUIDs as strings.
  ///
  static func readDevices() -> [String]
  {
    var deviceUUIDs:[String] = []
    
    let resultDictionary = getDictionaryFromPlist(title: "Devices")
    if (0 != resultDictionary.count)
    {
      deviceUUIDs = resultDictionary["Devices"] as! [String]
    }
    
    return deviceUUIDs
  }
  
  /// Determines if the Devices plist contains a specified UUID or not.
  ///
  /// @param[in]    The UUID to be found as a string.
  ///
  /// @return true  if the UUID is contained in the plist.
  ///         false otherwise.
  ///
  static func devicesContains(UUID:String) -> Bool
  {
    var retVal:Bool = false
    
    // Load the list of devices that are currently in the plist.
    var devices:[String] = readDevices()
    
    // Search for the UUID that was given
    var i:Int = 0
    var exit:Bool = false
    
    while (i < devices.count && !exit) {
      if (UUID == devices[i])
      {
        // If we find the device, exit the loop and return true.
        retVal = true
        exit = true
      }
      i += 1
    }
    
    return retVal
  }
  
  /// Loads the plist with the given title into a mutable dictionary object.
  ///
  /// @param[in] title  The title of the plist we want to load.
  ///
  /// @return A dictionary object representing the plist.
  ///         An empty dictionary if errors occurred or the plist could not be
  ///         found.
  ///
  static func getDictionaryFromPlist(title:String) -> NSMutableDictionary
  {
    var dict:NSMutableDictionary = [:]
    
    let fileManager = FileManager.default
    
    // Check to make sure the plist exists. If not, return an empty dictionary.
    let plistPath:String = plistExists(title: title)
    if ("" != plistPath)
    {
      // Load the contents of the plist into a dictionary.
      dict = NSMutableDictionary(contentsOfFile: plistPath)!
    }
    
    return dict
  }
  
  /// Checks to see if a plist with the given title exists in the Documents
  /// directory.
  ///
  /// @param[in] title  The title of the plist to search for.
  ///
  /// @return The path to the plist as a string, if the plist exists.
  ///         The empty string, if the plist doesn't exist.
  ///
  static func plistExists(title:String) -> String
  {
    var retPath:String = ""
    
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                      .userDomainMask,
                                                      true)[0] as String

    let plistPath = (docsDir as NSString)
                              .strings(byAppendingPaths: ["\(title).plist"])[0]
    if (fileManager.fileExists(atPath: plistPath))
    {
      retPath = plistPath as String
    }
    
    return retPath
  }
  
  /// Checks to see if the given element is already in the given list.
  ///
  /// @param[in] list     The list in which to check for the element.
  /// @param[in] element  The element to check for in the list.
  ///
  /// @return The index at which the element is found, if it is found.
  ///         -1, if it is not found.
  ///
  static func contains(list:[String], element:String) -> Int
  {
    var index:Int = -1
    
    var i:Int = 0
    var exit:Bool = false
    while (i < list.count && !exit)
    {
      if (element == list[i])
      {
        index = i
        exit = true
      }
      i += 1
    }
    
    return index
  }
}
