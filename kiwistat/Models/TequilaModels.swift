//
//  TequilaModels.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 12/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

/*
 USAGE:
 Tequila.shared contains a method called getFlights, this function needs the following parameters and returns the response from tequila:
 [1] date_from: Date
 [2] date_to: Date
 (Date range for the departure)
 [3] fly_from: String
 [4] fly_to: String
 (Departure - Destination, the string given must be 3 characters long and needs to be the airport code)
 [5] completion: Callback Function, lets you get the response or the errors raised
 */

import Foundation

struct BagsPrice: Codable {
    var one: Double?
    var two: Double?
    
    private enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
    }
}

struct BagLimit: Codable {
    var hand_width: Int
    var hand_height: Int
    var hand_length: Int
    var hand_weight: Int
    var hold_width: Int?
    var hold_height: Int?
    var hold_length: Int?
    var hold_dimensions_sum: Int?
    var hold_weight: Int?
}

struct Route: Codable, Identifiable {
    var id: String
    var cityTo: String
    var cityFrom: String
    var cityCodeFrom: String
    var cityCodeTo: String
    var flight_no: Int
    var operating_carrier: String
    var local_arrival: String
    var utc_arrival: String
    var local_departure: String
    var utc_departure: String
}

struct Flight: Codable, Identifiable {
    var id: String
    var bags_price: BagsPrice
    var baglimit: BagLimit
    var price: Int
    var route: [Route]
    var airlines: [String]
    var pnr_count: Int
    var has_airport_change: Bool
    var routes: [[String]]
    var deep_link: String
}

struct Fault: Codable {
    var faultstring: String
}

struct ErrorMessage: Codable {
    var param: String
    var errors: [String]
}

struct Response: Codable {
    var search_id: String?
    var data: [Flight]?
    var fault: Fault?
    var message: [ErrorMessage]?
}

class Tequila {
    private let apiKey: String = "5hy76dj3okEW9eP2FDY5QeVCGOGQ9TqZ"
    private let url: String = "http://kiwicom-prod.apigee.net/v2/search"
    
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    
    //Using singleton convention
    static let shared = Tequila()
    
    init() {}
    
    func getFlights(date_from: Date, date_to: Date, fly_from: String, fly_to: String, completion: @escaping (_ flights: Response?, _ error: Any?) -> Void) {
        
        //Conversion from Date to String (format: dd/MM/yyyy)
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        let date_from_string = df.string(from: date_from)
        let date_to_string = df.string(from: date_to)
        
        //Building a safe endpoint
        let endpointUrl = "\(self.url)?fly_from=\(fly_from)&fly_to=\(fly_to)&date_from=\(date_from_string)&date_to=\(date_to_string)"
        
        let safeEndpointUrlString = endpointUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let safeEndpointUrl = URL(string: safeEndpointUrlString!) else { return }
        
        //Building the HTTP GET request
        var request = URLRequest(url: safeEndpointUrl)
        request.httpMethod = "GET"
        request.setValue(self.apiKey, forHTTPHeaderField: "apikey")
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            //Decoding the response
            guard let jsonData = data else {
                fatalError("The payload is invalid \(String(describing: error)).")
            }
            
            let decoder = JSONDecoder()
            
            do {
                let flights = try decoder.decode(Response.self, from: jsonData)
                
                if flights.search_id != nil {
                    completion(flights, nil)
                } else {
                    completion(nil, flights.fault ?? flights.message)
                }
            }
            catch let error {
                completion(nil, error as NSError)
            }
        })
        
        dataTask.resume()
    }
}
