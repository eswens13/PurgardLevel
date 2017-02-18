//
//  BLEController.swift
//  Purgard Level
//
//  Created by Erik Swenson on 3/18/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import CoreBluetooth
import CoreData
import UIKit

class BLEController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate
{    
  // Relevant Services
  let UUID_CAPSENSE_SERVICE =
                      CBUUID(string: "00005AB5-0000-1000-8000-00805F9B34FB")
  let UUID_TEMPERATURE_SERVICE =
                      CBUUID(string: "00005000-0000-1000-8000-00805F9B34FB")
  let UUID_VOLTAGE_SERVICE =
                      CBUUID(string: "00005AFB-0000-1000-8000-00805F9B34FB")
  
  // Relevant Characteristics
  let UUID_CAPSENSE_SLIDER_CHARACTERISTIC =
                          CBUUID(string: "00005AA2-0000-1000-8000-00805F9B34FB")
  let UUID_TEMPERATURE_CHARACTERISTIC =
                          CBUUID(string: "00005A1B-0000-1000-8000-00805F9B34FB")
  let UUID_VOLTAGE_CHARACTERISTIC =
                          CBUUID(string: "00005A1A-0000-1000-8000-00805F9B34FB")
    
  // Client Config Descriptor
  let UUID_CLIENT_CONFIG_DESCRIPTOR =
                          CBUUID(string: "00002902-0000-1000-8000-00805F9B34FB")
  
  // The Central Manager for all Bluetooth interactions.
  static var centralManager: CBCentralManager?
  
  // An array of UUIDs for the services we care about.
  var serviceUuids: [CBUUID]?
  
  /// An array of UUIDs for the characteristics we care about.
  var characteristicUuids: [CBUUID]?
  
  // An array of devices that have been discovered.
  var availableDevices: [CBPeripheral]?
  
  // A reference to the table view controller.
  var deviceListViewController: DeviceListTableViewController?
  
  // A reference to the view controller displaying the device's information.
  var deviceViewController: ViewController?
  
  // A reference to the device that is currently connected.
  static var currentDevice: CBPeripheral?
  
  // Semaphores to signal when we're connected.
  let levelSem: DispatchSemaphore! = DispatchSemaphore(value: 0)
  let batterySem: DispatchSemaphore! = DispatchSemaphore(value: 0)
  let tempSem: DispatchSemaphore! = DispatchSemaphore(value: 0)
  
  // -------------------------------------------------------------------------
  // MARK: Constructor
  // -------------------------------------------------------------------------
  
  override init()
  {
    super.init()
    print("-- ERROR:  Using the wrong initializer")
  }
  
  init(listViewController: DeviceListTableViewController)
  {
    super.init()
    
    // Instantiate the central manager and make it run on a background dispatch
    // queue so it doesn't bog down UI operations.
    BLEController.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .userInitiated))
    deviceListViewController = listViewController
    serviceUuids = [CBUUID] ()
    characteristicUuids = [CBUUID] ()
    serviceUuids!.append(UUID_CAPSENSE_SERVICE)
    serviceUuids!.append(UUID_TEMPERATURE_SERVICE)
    serviceUuids!.append(UUID_VOLTAGE_SERVICE)
    characteristicUuids!.append(UUID_CAPSENSE_SLIDER_CHARACTERISTIC)
    characteristicUuids!.append(UUID_TEMPERATURE_CHARACTERISTIC)
    characteristicUuids!.append(UUID_VOLTAGE_CHARACTERISTIC)
    self.availableDevices = [CBPeripheral] ()
  }
  
  // -------------------------------------------------------------------------
  // MARK: CBCentralManagerDelegate protocol methods
  // -------------------------------------------------------------------------
  
  func centralManagerDidUpdateState(_ central: CBCentralManager)
  {
    return
  }
  
  func centralManager(_ central: CBCentralManager,
                      didDiscover peripheral: CBPeripheral,
                      advertisementData: [String : Any],
                      rssi RSSI: NSNumber)
  {
    self.availableDevices!.append(peripheral)
    //self.deviceListViewController!.loadView()
    DispatchQueue.main.async(execute:
    {
      self.deviceListViewController!.tableView?.reloadData()
    })
  }
    
  func centralManager(_ central: CBCentralManager,
                      didConnect peripheral: CBPeripheral)
  {
    print("CONNECTED")
    // Set the current device as the one we're connected to.
    BLEController.currentDevice = peripheral
    BLEController.currentDevice!.delegate = self
    
    // Add the device's UUID to the plist.
    let addResult:Bool = PListWriter.addDevice(
                UUID: BLEController.currentDevice!.identifier.uuidString)
    if (!addResult)
    {
      print("Didn't add the device to plist!")
    }
    
    // Start discovering the device's services.
    BLEController.currentDevice?.discoverServices(serviceUuids)
  }
  
  func centralManager(_ central: CBCentralManager,
                      didDisconnectPeripheral peripheral: CBPeripheral,
                      error: Error?)
  {
    if (error != nil)
    {
      print("Error disconnecting from device")
    }
    else
    {
      DispatchQueue.main.async(execute:
      {
        self.deviceViewController?.statsView.setConnectionStatus("Disconnected")
      })
      BLEController.currentDevice = nil
    }
  }
    
  func centralManager(_ central: CBCentralManager,
                      didFailToConnect peripheral: CBPeripheral,
                      error: Error?)
  {
    // TODO: Show an alert view in the list view controller
    DispatchQueue.main.async(execute:
    {
      let alertView = UIAlertController(
                            title: "Connection Failed",
                            message: "Failed to connect to \(peripheral.name!)",
                            preferredStyle: UIAlertControllerStyle.alert)
      alertView.addAction(
          UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.default,
                        handler: {(action: UIAlertAction!) in
                          alertView.dismiss(animated: true, completion: nil)
                        }))
    })
  }
  
  // -------------------------------------------------------------------------
  // MARK: CBPeripheralDelegate protocol methods
  // -------------------------------------------------------------------------
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
  {
    for service in peripheral.services!
    {
      switch service.uuid
      {
      case UUID_CAPSENSE_SERVICE:
        print("DISCOVERED LEVEL SERVICE")
        peripheral.discoverCharacteristics(
                          [UUID_CAPSENSE_SLIDER_CHARACTERISTIC], for: service)
        break
      case UUID_VOLTAGE_SERVICE:
        print("DISCOVERED BATTERY SERVICE")
        peripheral.discoverCharacteristics(
                          [UUID_VOLTAGE_CHARACTERISTIC], for: service)
        break
      case UUID_TEMPERATURE_SERVICE:
        print("DISCOVERED TEMPERATURE SERVICE")
        peripheral.discoverCharacteristics(
                          [UUID_TEMPERATURE_CHARACTERISTIC], for: service)
        break
      default:
        break
      }
    }
  }
    
  func peripheral(_ peripheral: CBPeripheral,
                  didDiscoverCharacteristicsFor service: CBService,
                  error: Error?)
  {
    for charac in service.characteristics!
    {
      switch charac.uuid
      {
      case UUID_CAPSENSE_SLIDER_CHARACTERISTIC:
        print("DISCOVERED LEVEL CHAR")
        BLEController.currentDevice!.setNotifyValue(true, for: charac)
        levelSem.signal()
        break
      case UUID_TEMPERATURE_CHARACTERISTIC:
        print("DISCOVERED TEMPERATURE CHAR")
        BLEController.currentDevice!.setNotifyValue(true, for: charac)
        tempSem.signal()
        break
      case UUID_VOLTAGE_CHARACTERISTIC:
        print("DISCOVERED BATTERY CHAR")
        BLEController.currentDevice!.setNotifyValue(true, for: charac)
        batterySem.signal()
        break
      default:
        break
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didUpdateNotificationStateFor characteristic: CBCharacteristic,
                  error: Error?)
  {
    if ((error) != nil) {
      print("Error: \(error?.localizedDescription)")
    }
    
    if (characteristic.isNotifying) {
      DispatchQueue.main.async(execute:
      {
        if ((self.deviceViewController != nil) &&
              (self.deviceViewController?.statsView != nil))
        {
          self.deviceViewController?.statsView.setConnectionStatus("Connected")
        }
      })
    }
    else {
      DispatchQueue.main.async(execute:
      {
        if ((self.deviceViewController != nil) &&
              (self.deviceViewController?.statsView != nil))
        {
          self.deviceViewController?.statsView
                                            .setConnectionStatus("Disconnected")
        }
      })
    }
  }
    
  func peripheral(_ peripheral: CBPeripheral,
                  didUpdateValueFor characteristic: CBCharacteristic,
                  error: Error?)
  {
    if ((error) != nil)
    {
      print("Error: \(error?.localizedDescription)")
    }
    else
    {
      if (self.deviceViewController != nil)
      {
        switch characteristic.uuid
        {
        case UUID_CAPSENSE_SLIDER_CHARACTERISTIC:
          
          // The level characteristic is an unsigned 8-bit integer. Convert
          // to an integer and send to view controller.
          var byte:UInt8 = 0x00
          (characteristic.value as NSData?)?.getBytes(&byte, length: 1)
          let intData:Int = Int(byte)
          DispatchQueue.main.async(execute:
          {
            self.deviceViewController!.updateProgress(intData)
          })
          break
          
        case UUID_VOLTAGE_CHARACTERISTIC:
            
          // The voltage characteristic is an unsigned 16-bit integer.
          // Convert to an integer and send to view controller.
          var byte:UInt8 = 0x00
          (characteristic.value as NSData?)?.getBytes(&byte, length: 1)
          let intData:Int = Int(byte)
          DispatchQueue.main.async(execute:
          {
            self.deviceViewController!.updateVoltage(intData)
          })
          break
            
        case UUID_TEMPERATURE_CHARACTERISTIC:
            
          // The temperature characteristic is a signed char in the range
          // of -127 to 127. It is in celcius, so we have to convert to 
          // fahrenheit.
          var byte:UInt8 = 0x00
          (characteristic.value as NSData?)?.getBytes(&byte, length: 1)
          let intData:Int = Int(byte)
          DispatchQueue.main.async(execute:
          {
            self.deviceViewController!.updateTemperature(intData)
          })
          break
            
        default:
            break
        }
      }
    }
  }
    
  // -------------------------------------------------------------------------
  // MARK: Helper Methods
  // -------------------------------------------------------------------------
    
  func getAvailableDevices() -> [CBPeripheral]
  {
    return self.availableDevices!
  }
  
  func startScan()
  {
    self.availableDevices = [CBPeripheral] ()
    //self.deviceListViewController?.loadView()
    DispatchQueue.main.async(execute:
    {
      self.deviceListViewController?.tableView?.reloadData()
    })
    BLEController.centralManager!.scanForPeripherals(
                                                withServices: self.serviceUuids,
                                                options: nil)
  }
  
  func stopScan()
  {
    BLEController.centralManager!.stopScan()
  }
  
  static func connectToDevice()
  {
    print("In connectToDevice")
    BLEController.centralManager!.connect(BLEController.currentDevice!,
                                          options: nil)
    print("Exiting connectToDevice")
  }
  
  func disconnectFromCurrentDevice()
  {
    if (BLEController.currentDevice == nil)
    {
      print("Current device null")
    }
    else
    {
      for service in (BLEController.currentDevice?.services)!
      {
        for characteristic in (service.characteristics)!
        {
          BLEController.currentDevice!.setNotifyValue(false,
                                                      for: characteristic)
        }
      }
    
      // Old version without the for loops. I think this only sets the
      // notification value to false for one of the possibly three
      // characteristics.
      //
      //let characteristic:CBCharacteristic =
      //                      (currentDevice?.services![0].characteristics![0])!
      //currentDevice!.setNotifyValue(false, for: characteristic)
    
      BLEController.centralManager!.cancelPeripheralConnection(
                            BLEController.currentDevice!)
    }
  }
    
}
