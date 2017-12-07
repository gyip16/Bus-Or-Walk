//
//  BusEstimates.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-12-06.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

class BusEstimates: EVObject {
    var RouteName: String?
    var RouteMap: RouteMap?
    var RouteNo: String?
    var Schedules: [Schedules]?
    var Direction: String?
}

class Schedules: EVObject {
    var Pattern: String?
    var Destination: String?
    var ExpectedLeaveTime: String?
    var ExpectedCountdown: String?
    var ScheduleStatus: String?
    var CancelledTrip: String?
    var CancelledStop: String?
    var AddedTrip: String?
    var AddedStop: String?
    var LastUpdate: String?
}

class RouteMap: EVObject {
    var Href: String = ""
}

class BusEstimateDataResponse {
    let apikey = "da7U5YMtuSBla2QK3msq"
    
    func loadBusStop(busStopNo: String, bus: String, completionHandler: @escaping (DataResponse<String>) -> Void) -> Alamofire.DataRequest {
        let parameters: Parameters = [
            "apikey": apikey,
            "count": 1,
            "timeframe": 1440,
            "routeNo": bus
            ] as [String: Any]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return Alamofire.request("https://api.translink.ca/rttiapi/v1/stops/\(busStopNo)/estimates", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseString { (response: DataResponse<String>) in
            switch response.result {
            case .success(let value):
                print("Estimate: \(value)")
                completionHandler(response)
            //print("Stop Number Data: \(busStop)")
            case .failure(let error):
                print("BusEstimate Error: \(error)")
                print("BusEstimate Response: \(response)")
                completionHandler(response)
            }
        }
    }
}

