//
//  DeviceListTableViewController.swift
//  Purgard Level
//
//  Created by Erik Swenson on 3/17/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import UIKit

class DeviceListTableViewController: UITableViewController,
                                     UIGestureRecognizerDelegate
{
  var bleController: BLEController?
  var plistReader:PListReader?
    
  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.navigationItem.title = "Available Devices"
    self.bleController = BLEController(listViewController: self)
    self.stopScan()
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews()
  {
    super.viewDidLayoutSubviews()
    
    if let rect = self.navigationController?.navigationBar.frame
    {
      let y = rect.size.height + rect.origin.y
      self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
    }
  }
  
  func scanForDevices()
  {
    let scanItem =
        UIBarButtonItem(title: "Stop",
                        style: .plain,
                        target: self,
                        action: #selector(DeviceListTableViewController.stopScan))
    self.navigationItem.rightBarButtonItem = scanItem
    self.bleController?.startScan()
    let timer =
      Timer.scheduledTimer(timeInterval: TimeInterval(5.0),
                           target: self,
                           selector: #selector(DeviceListTableViewController.stopScan),
                           userInfo: nil,
                           repeats: false)
  }
    
  func stopScan()
  {
    let scanItem =
      UIBarButtonItem(title: "Scan",
                      style: .plain,
                      target: self,
                      action: #selector(DeviceListTableViewController.scanForDevices))
    self.navigationItem.rightBarButtonItem = scanItem
    self.bleController?.stopScan()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int
  {
    return self.bleController!.getAvailableDevices().count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    // Get an instance of the cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell",
            for: indexPath) as! DeviceTableViewCell
    
    // Fill the labels with device info.
    let device = self.bleController!.getAvailableDevices()[indexPath.row]
    /*
      If we have connected to this device before, make the name bold.
     */
    cell.deviceNameLabel?.text = device.name
    cell.deviceAddressLabel?.text = "  " + device.identifier.uuidString
    
    return cell
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little
  // preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if (segue.identifier == "toLevelSegue") {
      let cellIndexPath = self.tableView.indexPath(for: sender as!
                                                    DeviceTableViewCell)
      
      // Get the next view controller
      let vc = segue.destination as! ViewController
      vc.navigationItem.title =
          self.bleController!.getAvailableDevices()[(cellIndexPath?.row)!].name
      vc.bleController = self.bleController
      self.bleController?.deviceViewController = vc
      vc.device =
          self.bleController!.getAvailableDevices()[(cellIndexPath?.row)!]

      // Add a back button to the navigation bar
      let backItem = UIBarButtonItem(title: "Devices",
                                     style: .plain,
                                     target: vc,
                                     action: nil)
      navigationItem.backBarButtonItem = backItem
    }
  }


}
