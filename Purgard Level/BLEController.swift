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

class BLEController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
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
  
  var centralManager: CBCentralManager?
  var serviceUuids: [CBUUID]?
  var characteristicUuids: [CBUUID]?
  var availableDevices: [CBPeripheral]?
  var cachedDevices: [CBPeripheral]?
  var deviceListViewController: DeviceListTableViewController?
  var deviceViewController: ViewController?
  var currentDevice: CBPeripheral?
  
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
    
    centralManager = CBCentralManager(delegate: self, queue: nil)
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
    self.deviceListViewController!.loadView()
  }
    
  func centralManager(_ central: CBCentralManager,
                      didConnect peripheral: CBPeripheral)
  {
    self.currentDevice = peripheral
    self.currentDevice!.delegate = self
    self.cachedDevices?.append(self.currentDevice)
    
    self.currentDevice?.discoverServices(serviceUuids)
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
      self.deviceViewController?.statsView.setConnectionStatus("Disconnected")
      self.currentDevice = nil
    }
  }
    
  func centralManager(_ central: CBCentralManager,
                      didFailToConnect peripheral: CBPeripheral,
                      error: Error?)
  {
    // TODO: Show an alert view in the list view controller
    let alertView = UIAlertController(title: "Connection Failed",
            message: "Failed to connect to \(peripheral.name!)",
            preferredStyle: UIAlertControllerStyle.alert)
    alertView.addAction(
        UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
            handler: {(action: UIAlertAction!) in
            alertView.dismiss(animated: true, completion: nil)
    }))
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
        peripheral.discoverCharacteristics(
                          [UUID_CAPSENSE_SLIDER_CHARACTERISTIC], for: service)
        break
      case UUID_VOLTAGE_SERVICE:
        peripheral.discoverCharacteristics(
                          [UUID_VOLTAGE_CHARACTERISTIC], for: service)
        break
      case UUID_TEMPERATURE_SERVICE:
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
        currentDevice!.setNotifyValue(true, for: charac)
        break
      case UUID_TEMPERATURE_CHARACTERISTIC:
        currentDevice!.setNotifyValue(true, for: charac)
        break
      case UUID_VOLTAGE_CHARACTERISTIC:
        currentDevice!.setNotifyValue(true, for: charac)
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
      deviceViewController?.statsView.setConnectionStatus("Connected")
    }
    else {
      deviceViewController?.statsView.setConnectionStatus("Disconnected")
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
      switch characteristic.uuid
      {
      case UUID_CAPSENSE_SLIDER_CHARACTERISTIC:
        
        // The level characteristic is an unsigned 8-bit integer. Convert
        // to an integer and send to view controller.
        var byte:UInt8 = 0x00
        (characteristic.value as NSData?)?.getBytes(&byte, length: 1)
        let intData:Int = Int(byte)
        deviceViewController!.updateProgress(intData)
        break
        
      case UUID_VOLTAGE_CHARACTERISTIC:
          
        // The voltage characteristic is an unsigned 16-bit integer.
        // Convert to an integer and send to view controller.
        var byte:UInt16 = 0x0000
        (characteristic.value as NSData?)?.getBytes(&byte, length: 2)
        let intData:Int = Int(byte)
        deviceViewController!.updateVoltage(intData)
        break
          
      case UUID_TEMPERATURE_CHARACTERISTIC:
          
        // The temperature characteristic is a signed char in the range
        // of -127 to 127. It is in celcius, so we have to convert to 
        // fahrenheit.
        var byte:Int8 = 0x00
        (characteristic.value as NSData?)?.getBytes(&byte, length: 1)
        let intData:Int = Int(byte)
        deviceViewController!.updateTemperature(intData)
        break
          
      default:
          break
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
    self.deviceListViewController?.loadView()
    self.centralManager!.scanForPeripherals(withServices: self.serviceUuids,
                                            options: nil)
  }
  
  func stopScan()
  {
    self.centralManager!.stopScan()
  }
  
  func connectToDevice(_ device: CBPeripheral)
  {
    self.centralManager!.connect(device, options: nil)
  }
  
  func disconnectFromCurrentDevice()
  {
    if (currentDevice == nil)
    {
      print("Current device null")
    }
    
    for service in (currentDevice?.services)!
    {
      for characteristic in (service.characteristics)!
      {
        currentDevice!.setNotifyValue(false, for: characteristic)
      }
    }
    
    // Old version without the for loops. I think this only sets the
    // notification value to false for one of the possibly three characteristics
    //
    //let characteristic:CBCharacteristic =
    //                        (currentDevice?.services![0].characteristics![0])!
    //currentDevice!.setNotifyValue(false, for: characteristic)
    
    self.centralManager!.cancelPeripheralConnection(self.currentDevice!)
  }
    
}
