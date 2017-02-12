//
//  DeviceListTableViewController.swift
//  Purgard Level
//
//  Created by Erik Swenson on 3/17/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import UIKit

class DeviceListTableViewController: UIViewController, UITableViewDelegate,
                                     UITableViewDataSource,
                                     UIGestureRecognizerDelegate
{
  var bleController: BLEController?
  var tableView: UITableView?
  
  // MARK: - Overrides
  
  // This is called once at application startup.
  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.navigationItem.title = "Available Devices"
    self.bleController = BLEController(listViewController: self)
    self.stopScan()
    
    tableView = UITableView()
    
    self.addLogoView()
  }
  
  // This is called whenever the table view controller becomes the main view
  // controller.
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tableView?.reloadData()
    self.addLogoView()
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews()
  {
    super.viewDidLayoutSubviews()
    /*
    if let rect = self.navigationController?.navigationBar.frame
    {
      let y = rect.size.height + rect.origin.y
      self.tableView?.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
    }
     */
  }
  
  // MARK: - Helper Functions
  
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
  
  func addLogoView()
  {
    let statusBarFrame = UIApplication.shared.statusBarFrame
    let statusBarHeight = statusBarFrame.height
    
    let navFrame = self.navigationController?.navigationBar.frame
    let navHeight = navFrame?.height
    
    let screenRect = UIScreen.main.bounds
    let screenWidth = screenRect.width
    let screenHeight = screenRect.height - navHeight! - statusBarHeight
    
    let viewHeight:CGFloat = (2.0 / 3.0) * CGFloat(screenWidth)
    print("viewHeight = \(viewHeight)")
    let imageView:UIImageView =
                  UIImageView(frame: CGRect(x: 0,
                                            y: (screenHeight - viewHeight) + 100,
                                            width: screenWidth,
                                            height: viewHeight))
    imageView.image = UIImage(named: "Logo")
    imageView.contentMode = .scaleAspectFit
    self.view.addSubview(imageView)
  }

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }

  func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int
  {
    return self.bleController!.getAvailableDevices().count
  }

  func tableView(_ tableView: UITableView,
                    cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    // Get an instance of the cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell",
            for: indexPath) as! DeviceTableViewCell
    
    // Fill the labels with device info.
    let device = self.bleController!.getAvailableDevices()[indexPath.row]

    // If we have connected to this device before, make the name bold.
    if (PListReader.devicesContains(UUID: device.identifier.uuidString))
    {
      let boldNameDescriptor:UIFontDescriptor =
        cell.deviceNameLabel.font.fontDescriptor.withSymbolicTraits(.traitBold)!
      let boldNameFont:UIFont = UIFont(descriptor: boldNameDescriptor, size: 0)
      
      cell.deviceNameLabel.font = boldNameFont
      
      let boldAddressDescriptor:UIFontDescriptor =
        cell.deviceAddressLabel.font.fontDescriptor
          .withSymbolicTraits(.traitBold)!
      let boldAddressFont:UIFont = UIFont(descriptor: boldAddressDescriptor,
                                          size: 0)
      
      cell.deviceAddressLabel.font = boldAddressFont
    }
    
    // Set the name of the device and the UUID of the device appropriately.
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
      let cellIndexPath = self.tableView?.indexPath(for: sender as!
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
