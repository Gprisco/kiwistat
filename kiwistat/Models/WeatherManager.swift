//
//  WeatherManager.swift
//  kiwistat
//
//  Created by Simone Serra Cassano on 14/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

struct WeatherBit: Codable{
    let data: [WeatherData]
}

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let temp: Double
    let precip: Double
    let clouds: Int
    let weather: Weather
    let datetime: String
}

struct Weather: Codable {
    let icon: String
}

class WeatherManager {
    
    //    Singleton
    static let shared = WeatherManager()
    init() {}
    
    let weatherURL = "https://api.weatherbit.io/v2.0/forecast/daily?key=89bbb73a0dac472482c3b312a4cea068"
    
    func fetchWeather(cityName: String, countryID: String, completion: @escaping ([WeatherData]) -> Void) {
        let urlString = "\(weatherURL)&city=\(cityName)&country=\(countryID)"
        performRequest(with: urlString, completion: { weatherData in
            completion(weatherData.data)
        })
    }
    
    func performRequest(with urlString: String, completion: @escaping (WeatherBit) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    completion(self.parseJSON(safeData))
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherBit {
        let decoder = JSONDecoder()
        
        var decodedWeatherData: WeatherBit?
        
        do {
            decodedWeatherData = try decoder.decode(WeatherBit.self, from: weatherData)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return decodedWeatherData!
        
    }
    
}
