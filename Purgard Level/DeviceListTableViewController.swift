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
  @IBOutlet weak var tableView: UITableView?
  
  // MARK: - Overrides
  
  // This is called once at application startup.
  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.navigationItem.title = "Available Devices"
    self.bleController = BLEController(listViewController: self)
    self.stopScan()

    self.addLogoView()
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    self.tableView?.reloadData()
  }
  
  // This is called whenever the table view controller becomes the main view
  // controller.
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews()
  {
    super.viewDidLayoutSubviews()
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
    
    // The logo is 2:3 aspect ratio and we want it to take up 2/3 of the screen
    // width.
    let viewHeight:CGFloat = (4.0 / 9.0) * CGFloat(screenWidth)
    
    let imageView:UIImageView =
                  UIImageView(frame: CGRect(x: 0,
                                            y: navHeight! + statusBarHeight +
                                                    (screenHeight - viewHeight),
                                            width: screenWidth,
                                            height: viewHeight))
    imageView.image = UIImage(named: "Logo")
    imageView.backgroundColor = UIColor.white
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
    let rows = self.bleController!.getAvailableDevices().count
    return rows
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
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 90
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
