//
//  MyTableViewController.swift
//  SWJSONTable
//
//  Created by Don Magnusson on 6/14/16.
//  Copyright © 2016 DonMag. All rights reserved.
//

import UIKit

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
		
		guard let url: NSURL = NSURL(string: "http://jsonplaceholder.typicode.com/users") else {
			return
		}
		let urlRequest = NSURLRequest(URL: url)
		
		let config = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: config)
		
		let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
			guard let responseData = data else {
				print("Error: did not receive data")
				return
			}
			guard error == nil else {
				print("error calling GET on /posts/1")
				print(error)
				return
			}
			
			// parse the result as JSON, since that's what the API provides
			
			do {
				let JSON = try NSJSONSerialization.JSONObjectWithData(responseData, options:NSJSONReadingOptions(rawValue: 0))
				guard let JSONArray :NSArray = JSON as? NSArray else {
					print("Not an Array")
					// put in function
					return
				}
				self.aData = NSMutableArray(array: JSONArray)

				print("JSONArry! \(JSONArray)")
			} catch let JSONError as NSError {
				print("\(JSONError)")
			}
			
			
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				
				self.tableView.reloadData()
				
			})

		})
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
			
			let dd = aData[indexPath.row]
			
			guard let d = dd as? NSDictionary else {
				cell.textLabel?.text = "Whoops \(indexPath.row)"
				return cell
			}
			
			let tName = d.objectForKey("name")
			
			guard let sName: NSString = tName as? NSString else {
				cell.textLabel?.text = "Whoops 2 \(indexPath.row)"
				return cell
			}
			
			cell.textLabel?.text = sName as String

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
