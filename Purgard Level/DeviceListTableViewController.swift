//
//  DeviceListTableViewController.swift
//  Purgard Level
//
//  Created by Erik Swenson on 3/17/16.
//  Copyright © 2016 ErikSwenson. All rights reserved.
//

import UIKit

class DeviceListTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var bleController: BLEController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.navigationItem.title = "Available Devices"
        self.bleController = BLEController(listViewController: self)
        self.stopScan()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    func scanForDevices() {
        
        let scanItem = UIBarButtonItem(title: "Stop", style: .Plain, target: self, action: "stopScan")
        self.navigationItem.rightBarButtonItem = scanItem
        self.bleController?.startScan()
        let timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(5.0), target: self, selector: "stopScan", userInfo: nil, repeats: false)
        
    }
    
    func stopScan() {
        
        let scanItem = UIBarButtonItem(title: "Scan", style: .Plain, target: self, action: "scanForDevices")
        self.navigationItem.rightBarButtonItem = scanItem
        self.bleController?.stopScan()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bleController!.getAvailableDevices().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get an instance of the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell",
                forIndexPath: indexPath) as! DeviceTableViewCell
        
        // Set the properties of the cell
        cell.deviceNameLabel?.text = self.bleController!.getAvailableDevices()[indexPath.row].name
        cell.deviceAddressLabel?.text = self.bleController!.getAvailableDevices()[indexPath.row].identifier.UUIDString
        
        return cell
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "toLevelSegue") {
            let cellIndexPath = self.tableView.indexPathForCell(sender as! DeviceTableViewCell)
            
            // Get the next view controller
            let vc = segue.destinationViewController as! ViewController
            vc.navigationItem.title = self.bleController!.getAvailableDevices()[(cellIndexPath?.row)!].name
            vc.bleController = self.bleController
            self.bleController?.deviceViewController = vc
            vc.device = self.bleController!.getAvailableDevices()[(cellIndexPath?.row)!]

            // Add a back button to the navigation bar
            let backItem = UIBarButtonItem(title: "Devices", style: .Plain, target: vc, action: nil)
            navigationItem.backBarButtonItem = backItem
                    
        }
        
    }


}
