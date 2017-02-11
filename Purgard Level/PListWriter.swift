//
//  PListWriter.swift
//  Purgard Level
//
//  Created by Erik Swenson on 2/3/17.
//  Copyright © 2017 ErikSwenson. All rights reserved.
//

import Foundation

/// This class is used to add entries to or modify entries in any plist used by
/// this application. The code for this class comes in large part from the Stack
/// Overflow post located at:
///     http://stackoverflow.com/questions/24692746/write-to-plist-file-in-swift
///
class PListWriter {

  /// Attempts to copy the Devices plist to the Documents directory so that we
  /// can modify the entries. The plist that comes as part of the app bundle is,
  /// by default, read only.
  ///
  /// @return true  if the the Devices plist was successfully copied or it
  ///               already exists in the Documents directory.
  ///         false otherwise.
  ///
  static func copyDevicesToDocsDir() -> Bool
  {
    var retVal:Bool = true
    let devicesPath = PListReader.plistExists(title: "Devices")
    
    // Check to see if the plist has already been copied over to the Documents
    // directory. If it has, do nothing (we can read and write from that plist).
    // If it hasn't, we'll create a copy and place it in the Documents
    // directory.
    if ("" == devicesPath)
    {
      // Get the path of the plist that is part of the main bundle.
      if let bundlePath = Bundle.main.path(forResource: "Devices",
                                           ofType: "plist")
      {
        // We can use this for debugging if needed.
        //let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
        //                                            as? [String:AnyObject]
        
        // Copy the plist from the app bundle to the Documents directory.
        do
        {
          let fileManager = FileManager.default
          try fileManager.copyItem(atPath: bundlePath, toPath: devicesPath)
        }
        catch
        {
          print("Could not copy the file \'Devices.plist\' to Documents dir!")
          retVal = false
        }
        
      }
      else
      {
        // The plist does not exist in the bundle.
        print("The file \'Devices.plist\' could not be found!")
        retVal = false
      }
    }
    
    return retVal
  }
  
  /// Attempts to add a new device to the Devices plist in the Documents
  /// directory.
  ///
  /// @param[in]    The UUID of the device to add.
  ///
  /// @return true  if the device was successfully added to the plist or if the
  ///               plist already contains the device.
  ///         false otherwise.
  ///
  static func addDevice(UUID:String) -> Bool
  {
    var retVal:Bool = true
    
    // Check to make sure the plist exists. Exit with an error if it does not.
    let plistPath = PListReader.plistExists(title: "Devices")
    if ("" != plistPath)
    {
      // Copy the contents of the plist to a mutable dictionary so we can add
      // new entries.
      var devicesDictionary =
                            PListReader.getDictionaryFromPlist(title: "Devices")
      var deviceUUIDs = devicesDictionary["Devices"] as! [String]
      
      // Add the device UUID to the list if it is not already in the list.
      if (-1 == PListReader.contains(list: deviceUUIDs, element: UUID))
      {
        deviceUUIDs.append(UUID)
        devicesDictionary.setValue(deviceUUIDs, forKey: "Devices")
      }
      
      // Write the modified dictionary to the plist.
      devicesDictionary.write(toFile: plistPath, atomically: false)
    }
    else
    {
      print("The file \'Devices.plist\' does not exist in the Documents dir!")
      retVal = false
    }
    
    return retVal
  }
  
  /// Attempts to destroy the plist with the specified title in the Documents
  /// directory.
  ///
  /// @param[in]    The title of the plist to destroy.
  ///
  /// @return true  if the plist was destroyed or no plist with the specified
  ///               title exists in the Documents directory.
  ///         false if the plist was found, but could not be destroyed.
  ///
  static func destroyPlist(title:String) -> Bool
  {
    var retVal:Bool = true
    
    // Check to see if the file exists. If it doesn't, exit with success.
    let plistPath = PListReader.plistExists(title: title)
    if ("" != plistPath)
    {
      // Try to delete the plist file. If there are errors exit with an error.
      do
      {
        let fileManager = FileManager.default
        try fileManager.removeItem(atPath: plistPath)
      }
      catch
      {
        print("Could not delete the file \'\(title).plist\'!")
        retVal = false
      }
    }
    
    return retVal
  }
  
}
