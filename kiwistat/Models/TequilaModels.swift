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

struct BagsPrice: Hashable, Codable {
    var one: Double?
    var two: Double?
    
    private enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
    }
}

struct BagLimit: Hashable, Codable {
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

struct Route: Hashable, Codable, Identifiable {
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

struct CountryTo: Hashable, Codable {
    var code: String
}

struct Flight: Hashable, Codable, Identifiable {
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
    var cityFrom: String
    var cityTo: String
    var countryTo: CountryTo
    var local_arrival: String
    var utc_arrival: String
    var local_departure: String
    var utc_departure: String
}

struct Fault: Hashable, Codable {
    var faultstring: String
}

struct ErrorMessage: Hashable, Codable {
    var param: String
    var errors: [String]
}

struct Response: Hashable, Codable {
    var search_id: String?
    var data: [Flight]?
    var fault: Fault?
    var message: [ErrorMessage]?
}

struct FetchedData: Codable, Identifiable {
    var id = UUID()
    var flight: Flight
    var weather: [WeatherData]
}

class Tequila: ObservableObject {
    @Published var response = [FetchedData]()
    
    var flyFrom: String = ""
    var flyTo: String = ""
    var dateFrom: Date
    var dateTo: Date
    
    var lastWeatherLocations: [String] = []
    var lastWeatherData = [WeatherData]()
    var lastDate: String = ""
    
    private let apiKey: String = "5hy76dj3okEW9eP2FDY5QeVCGOGQ9TqZ"
    private let url: String = "https://kiwicom-prod.apigee.net/v2/search"
    
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    
    init(date_from: Date, date_to: Date, fly_from: String, fly_to: String) {
        self.dateFrom = date_from
        self.dateTo = date_to
        self.flyFrom = fly_from
        self.flyTo = fly_to
    }
    
    func fetchFlights(completion: @escaping (FetchedData) -> Void) {
        //Conversion from Date to String (format: dd/MM/yyyy)
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        let date_from_string = df.string(from: self.dateFrom)
        let date_to_string = df.string(from: self.dateTo)
        
        //Building a safe endpoint
        let endpointUrl = "\(self.url)?fly_from=\(self.flyFrom)&fly_to=\(flyTo)&date_from=\(date_from_string)&date_to=\(date_to_string)"
        
        let safeEndpointUrlString = endpointUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let safeEndpointUrl = URL(string: safeEndpointUrlString!) else { return }
        
        //Building the HTTP GET request
        var request = URLRequest(url: safeEndpointUrl)
        request.httpMethod = "GET"
        request.setValue(self.apiKey, forHTTPHeaderField: "apikey")
        
        self.loadJson(request: request, completion: { response in
            df.dateFormat = "yyyy-MM-dd"
            
            for flight in response.data! {
                let isoDate = flight.local_arrival.iso8601Date!
                let date = df.string(from: isoDate)
                
                if !self.lastWeatherLocations.contains(flight.cityTo) || date != self.lastDate {
                    WeatherManager.shared.fetchWeather(
                        cityName: flight.cityTo,
                        countryID: flight.countryTo.code,
                        completion: { weatherData in
                            let firstUsefulIndex = weatherData.firstIndex(where: { $0.datetime == date })!
                            let weather = weatherData.suffix(weatherData.count - firstUsefulIndex) as [WeatherData]
                            
                            DispatchQueue.main.async {
                                completion(FetchedData(flight: flight, weather: weather))
                                self.lastWeatherLocations.append(flight.cityTo)
                                self.lastWeatherData = weather
                                self.lastDate = weather[0].datetime
                            }
                        }
                    )
                }
                else {
                    completion(FetchedData(flight: flight, weather: self.lastWeatherData))
                }
            }
        })
    }
    
    func loadJson(request: URLRequest, completion: @escaping (_ flights: Response) -> Void) {
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            //Decoding the response
            guard let jsonData = data else {
                fatalError("The payload is invalid \(String(describing: error)).")
            }
            
            let decoder = JSONDecoder()
            
            do {
                let flights = try decoder.decode(Response.self, from: jsonData)
                
                completion(flights)
            }
            catch let error {
                fatalError(error.localizedDescription)
            }
        }
        ).resume()
    }
}
