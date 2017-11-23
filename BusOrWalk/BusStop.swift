//
//  BusStop.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-11-22.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import Foundation
import EVReflection
import Alamofire

// MARK: BusStop Model

class BusStop: EVObject {
    var StopNo: String?
    var BayNo: String?
    var Latitude: String?
    var OnStreet: String?
    var WheelchairAccess: String?
    var AtStreet: String?
    var Longitude: String?
    var Routes: String?
    var Name: String?
    var Distance: String?
    var City: String?
}

// MARK: BusStopDataResponse
class BusStopDataResponse {
    
    @discardableResult
    func loadBusStop(busStopNo: String, completionHandler: @escaping (DataResponse<BusStop>) -> Void) -> Alamofire.DataRequest {
        let apikey = "da7U5YMtuSBla2QK3msq"
        let parameters: Parameters = [
            "apikey": apikey
            ] as [String: Any]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return Alamofire.request("https://api.translink.ca/rttiapi/v1/stops/\(busStopNo)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseObject { (response: DataResponse<BusStop>) in
            switch response.result {
            case .success(let value):
                print("\(value)")
                completionHandler(response)
            //print("Stop Number Data: \(busStop)")
            case .failure(let error):
                print("busstopchange \(error)")
                print("something \(response)")
                completionHandler(response)
            }
        }
    }
}
