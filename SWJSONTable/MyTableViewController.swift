//
//  MyTableViewController.swift
//  SWJSONTable
//
//  Created by DonMag on 6/14/16.
//  Copyright © 2016 DonMag. All rights reserved.
//

import UIKit

// makes me wonder

class MyTableViewController: UITableViewController {

	var aData: NSMutableArray = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		// use an empty view for the table header (just to push it down from the top of the window)
		self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
		
		self.getJsonFromURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	// MARK: - Data handling
	
	func getJsonFromURL () {
		
		let urlString = "https://itunes.apple.com/us/rss/topmovies/limit=100/json"
		
		guard let url: NSURL = NSURL(string: urlString) else {
			return
		}
		
		
		let urlRequest = NSURLRequest(URL: url)
		
		let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) {
			data, response, error in
			if let data = data
				where error == nil {
					
					var jd: NSMutableDictionary!
					
					do {
						jd = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSMutableDictionary
					} catch _ as NSError {
						print("error=\(error!.localizedDescription)")
						return
					}
					
					guard let jdA = jd["feed"] as? NSDictionary else {
						print("feed is not a Dictionary")
						return
					}
					
					guard let jdE = jdA["entry"] as? Array<NSDictionary> else {
						print("entry is not a Array")
						return
					}
					
					self.aData = NSMutableArray(array: jdE)
					
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.tableView.reloadData()
					})
					
			} else {
				print("error=\(error!.localizedDescription)")
			}
		}
		
		task.resume()

	}
	
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if aData is empty, we haven't rec'd the data yet (or there was an error)
		// return 1 so we can put a message in the first row of the table
		if self.aData.count == 0 {
			return 1
		}
        return self.aData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)

        // Configure the cell...
		if self.aData.count == 0 {
			// if aData is empty, we haven't rec'd the data yet (or there was an error)
			cell.textLabel?.text = "Loading..."
		} else {
			
			guard let d = aData[indexPath.row] as? NSDictionary else {
				cell.textLabel?.text = "Whoops \(indexPath.row)"
				return cell
			}
			
			guard let dName: NSDictionary = d["im:name"] as? NSDictionary else {
				cell.textLabel?.text = "Whoops 2 \(indexPath.row)"
				return cell
			}
			
			guard let sName: String = dName["label"] as? String else {
				cell.textLabel?.text = "Whoops 3 \(indexPath.row)"
				return cell
			}
			
			cell.textLabel?.text = sName //as String

		}
		
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
