//
//  ResultViewController.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-12-05.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    //MARK: Const Properties
    let AverageWalkingSpeed: Double = 5000.0 //meters per hour
    let MinutesInHour: Double = 60.0 //minutes
    
    //MARK: Properties
    var SelectedStop = BusStop()
    var CurrentStop = BusStop()
    var SelectedRoute = String()
    var CurrentEstimate = BusEstimates()
    var currentETAString = String()
    var currentETADate: Date? = nil
    var destinationETAString = String()
    var destinationETADate: Date? = nil
    var metersperminute: Double?
    //MARK: UI Elements
    
    @IBOutlet weak var RouteLabel: UILabel!
    @IBOutlet weak var Destinationlabel: UILabel!
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var walkOrWaitLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    func configureView() {
        var translinkDataFatalFormatFlag = false
        // Update the user interface for the detail item.
        RouteLabel.text = SelectedRoute
        Destinationlabel.text = SelectedStop.StopNo
        destinationLocation.text = SelectedStop.Name
        distanceLabel.text = "\(SelectedStop.Distance!)m"
        let current = BusEstimateDataResponse()
        current.loadBusStop(busStopNo: CurrentStop.StopNo!, bus: SelectedRoute) { response in
            if let c = response.value {
                print("\(c)")
                let clist = [BusEstimates](json: c)
                let CurrentEstimate = clist[0]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                var earliestTime: String? = ""
                var earliestDate: Date? = nil
                for schedule in CurrentEstimate.Schedules! {
                    if(earliestDate == nil) {
                        if schedule.ExpectedLeaveTime!.count <= 7 {
                            print("formatchanged1")
                            dateFormatter.dateFormat = "h:mma"
                            var times = [String]()
                            times.append(schedule.ExpectedLeaveTime!)
                            let dateArray = times.map { Calendar.current.dateComponents([.hour, .minute], from: dateFormatter.date(from:$0)!) }
                            let upcomingTime = dateArray.map { Calendar.current.nextDate(after: Date(), matching: $0, matchingPolicy: .nextTime)!  }
                            dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                            print("\(dateFormatter.string(from: upcomingTime[0]))")
                            
                            earliestTime = String(dateFormatter.string(from: upcomingTime[0]).prefix(7))
                            earliestDate = upcomingTime[0]
                        } else {
                            earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                            earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                        }
                    } else {
                        if schedule.ExpectedLeaveTime!.count <= 7 {
                            print("formatchanged2")
                            dateFormatter.dateFormat = "h:mma"
                            var times = [String]()
                            times.append(schedule.ExpectedLeaveTime!)
                            let dateArray = times.map { Calendar.current.dateComponents([.hour, .minute], from: dateFormatter.date(from:$0)!) }
                            let upcomingTime = dateArray.map { Calendar.current.nextDate(after: Date(), matching: $0, matchingPolicy: .nextTime)!  }
                            dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                            print("\(dateFormatter.string(from: upcomingTime[0]))")
                            
                            earliestTime = String(dateFormatter.string(from: upcomingTime[0]).prefix(7))
                            earliestDate = upcomingTime[0]
                        } else {
                            if (earliestDate! > dateFormatter.date(from: schedule.ExpectedLeaveTime!)!) {
                                earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                                earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                            }
                        }
                    }
                }
                if(earliestDate == nil) {
                    translinkDataFatalFormatFlag = true
                    self.walkOrWaitLabel.text = "Bus Aint Coming Soon"
                    self.walkOrWaitLabel.textColor = UIColor.red
                    self.resultLabel.text = "If you got here, Translink screwed up."
                    self.resultLabel.textColor = UIColor.red
                    self.etaLabel.text = "Sorry. Cannot get Correct Data"
                    self.etaLabel.textColor = UIColor.red
                } else {
                    self.currentETADate = earliestDate!
                    self.currentETAString = earliestTime!
                    self.etaLabel.text = earliestTime!
                    self.destinationInfo()
                }

                
            } else {
                print("error in estimates")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        metersperminute = AverageWalkingSpeed/MinutesInHour
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
                        if schedule.ExpectedLeaveTime!.count <= 7 {
                            print("formatchanged3")
                            dateFormatter.dateFormat = "h:mma"
                            var times = [String]()
                            times.append(schedule.ExpectedLeaveTime!)
                            let dateArray = times.map { Calendar.current.dateComponents([.hour, .minute], from: dateFormatter.date(from:$0)!) }
                            let upcomingTime = dateArray.map { Calendar.current.nextDate(after: Date(), matching: $0, matchingPolicy: .nextTime)!  }
                            dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                            print("\(dateFormatter.string(from: upcomingTime[0]))")
                            
                            earliestTime = String(dateFormatter.string(from: upcomingTime[0]).prefix(7))
                            earliestDate = upcomingTime[0]
                        } else {
                            earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                            earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                        }
                    } else {
                        if schedule.ExpectedLeaveTime!.count <= 7 {
                            print("formatchanged4")
                            dateFormatter.dateFormat = "h:mma"
                            var times = [String]()
                            times.append(schedule.ExpectedLeaveTime!)
                            let dateArray = times.map { Calendar.current.dateComponents([.hour, .minute], from: dateFormatter.date(from:$0)!) }
                            let upcomingTime = dateArray.map { Calendar.current.nextDate(after: Date(), matching: $0, matchingPolicy: .nextTime)!  }
                            dateFormatter.dateFormat = "hh:mma yyyy-MM-dd"
                            print("\(dateFormatter.string(from: upcomingTime[0]))")
                            
                            earliestTime = String(dateFormatter.string(from: upcomingTime[0]).prefix(7))
                            earliestDate = upcomingTime[0]
                        } else {
                            if (earliestDate! > dateFormatter.date(from: schedule.ExpectedLeaveTime!)!) {
                                earliestTime = String(schedule.ExpectedLeaveTime!.prefix(7))
                                earliestDate = dateFormatter.date(from: schedule.ExpectedLeaveTime!)
                            }
                        }
                    }
                }
                if(earliestDate == nil) {
                    self.walkOrWaitLabel.text = "Bus Aint Coming Soon"
                    self.walkOrWaitLabel.textColor = UIColor.red
                    self.resultLabel.text = "If you got here, Translink screwed up."
                    self.resultLabel.textColor = UIColor.red
                } else {
                    self.destinationETADate = earliestDate!
                    self.destinationETAString = earliestTime!
                    var thecomponents = Calendar.current.dateComponents([.minute], from: self.currentETADate!, to: self.destinationETADate!)
                    if(thecomponents.minute! >= 0) {
                        let diffMinutes = Double(thecomponents.minute!)
                        let walkETA = (Double(self.SelectedStop.Distance!)! / self.metersperminute!)
                        print("diffMinutes: \(diffMinutes)")
                        print("WalkETA: \(walkETA)")
                        if ( walkETA < diffMinutes) {
                            print("print suces time : \(thecomponents.minute!)")
                            
                            
                            self.walkOrWaitLabel.text = "WALK!"
                            self.walkOrWaitLabel.textColor = UIColor.green
                            self.resultLabel.text = "You can walk there in: " + String(format: "%.2f", walkETA) + " min"
                        } else {
                            print("print wait time :\(thecomponents.minute!)")
                            self.walkOrWaitLabel.text = "WAIT!"
                            self.walkOrWaitLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
                            self.resultLabel.text = "Bus is Faster"
                            self.resultLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
                        }
                    } else {
                        print("print wait 2 time :\(thecomponents.minute!)")
                        self.walkOrWaitLabel.text = "WAIT!"
                        self.walkOrWaitLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
                        self.resultLabel.text = "Bus is Faster"
                        self.resultLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
                    }
                }
            }
        }
    }

    
    
}

