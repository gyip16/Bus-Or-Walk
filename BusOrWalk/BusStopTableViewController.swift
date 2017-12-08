//
//  BusStopTableViewController.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-12-06.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import UIKit

class BusStopTableViewController: UITableViewController {

    //MARK: Properties
    var busStops = [BusStop]()
    var currentStop = BusStop()
    var viewTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = viewTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return busStops.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BusStopTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BusStopTableViewCell else {
            fatalError("dequeued cell is not an instance of BusStopTableViewCell.")
        }
        let busStop = busStops[indexPath.row]

        // Configure the cell...
        
        cell.BusStopNumber.text = busStop.StopNo
        cell.BusStopLocation.text = busStop.Name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        if(checkNetwork()) {
            performSegue(withIdentifier: "segueToResults", sender: self)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToResults" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? ResultViewController {
                    destination.SelectedStop = busStops[indexPath.row]
                    destination.CurrentStop = currentStop
                    destination.SelectedRoute = self.title!
                }
            }
        }
        
    }
    
    //MARK: Internet Connectivity Check
    func checkNetwork() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        } else {
            print("Internet Connection not Available!")
            let alertController = UIAlertController(title: "No Network", message: "No internet connection found. Please try again later.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return false
        }
    }
    

}
