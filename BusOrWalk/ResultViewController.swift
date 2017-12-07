//
//  ResultViewController.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-12-05.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    //MARK: Properties
    var SelectedStop = BusStop()
    var CurrentStop = BusStop()
    var SelectedRoute = String()
    var CurrentEstimate = BusEstimates()
    var currentETAString = String()
    var currentETADate: Date? = nil
    var destinationETAString = String()
    var destinationETADate: Date? = nil
    //MARK: UI Elements
    
    @IBOutlet weak var RouteLabel: UILabel!
    @IBOutlet weak var Destinationlabel: UILabel!
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var walkOrWaitLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        RouteLabel.text = SelectedRoute
        Destinationlabel.text = SelectedStop.StopNo
        destinationLocation.text = SelectedStop.Name
        distanceLabel.text = "\(SelectedStop.Distance!)m"
        let current = BusEstimateDataResponse()
        current.loadBusStop(busStopNo: CurrentStop.StopNo!, bus: SelectedRoute) { response in
            if let c = response.value {
                let clist = [BusEstimates](json: c)
                let CurrentEstimate = clist[0]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                var earliestTime: String? = ""
                var earliestDate: Date? = nil
                for schedule in CurrentEstimate.Schedules! {
                    if(earliestDate == nil) {
                        earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                        earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                    } else {
                        if (earliestDate! > dateFormatter.date(from: schedule.ExpectedLeaveTime!)!) {
                            earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                            earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                        }
                    }
                }
                self.currentETADate = earliestDate!
                self.currentETAString = earliestTime!
                self.etaLabel.text = earliestTime!
                self.destinationInfo()
                
            } else {
                print("error in estimates")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func destinationInfo() {
        let destination = BusEstimateDataResponse()
        destination.loadBusStop(busStopNo: SelectedStop.StopNo!, bus: SelectedRoute) { response in
            if let d = response.value {
                print("d: \(d)")
                let dlist = [BusEstimates](json: d)
                let DestinationEstimate = dlist[0]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                var earliestTime: String? = ""
                var earliestDate: Date? = nil
                for schedule in DestinationEstimate.Schedules! {
                    if(earliestDate == nil) {
                        earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                        earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                    } else {
                        if (earliestDate! > dateFormatter.date(from: schedule.ExpectedLeaveTime!)!) {
                            earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                            earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                        }
                    }
                }
                self.destinationETADate = earliestDate!
                self.destinationETAString = earliestTime!
                var thecomponents = Calendar.current.dateComponents([.minute], from: self.currentETADate!, to: self.destinationETADate!)
                if(thecomponents.minute! > 0) {
                    print("print time :\(thecomponents.minute!)")
                } else {
                    print("stay")
                }
            }
        }
    }

    
    
}

