//
//  PatchBrowser.swift
//  FinalProject
//
//  Created by Samuel Johnson on 3/14/16.
//  Copyright © 2016 Samuel Johnson. All rights reserved.
//

import UIKit
import Foundation

class PatchBrowser: UITableViewController {
    
    var numberOfFiles = 0
    var patchList = ["P6AMB", "P6FAT", "BELL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patchList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PatchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PatchTableViewCell
        let patchName = patchList[indexPath.row]
        cell.patchName.text = patchName
        return cell
        
    }
    
    var toPassPatchName: String!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Patch Selected: \(patchList[indexPath.row])")
        
        // get the patch name
        let patchIndex = tableView.indexPathForSelectedRow!
        let patchName = patchList[patchIndex.row]
        toPassPatchName = patchName
        performSegueWithIdentifier("returnToMain", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "returnToMain") {
            
            let viewController = segue.destinationViewController as! SynthViewController
            
            viewController.currentPatch = toPassPatchName
            
        }
    }
    
}
