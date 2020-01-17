//
//  IATACodesApi.swift
//  kiwistat
//
//  Created by Antonio Alfonso on 17/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

import Foundation

struct RequestAutocomplete: Codable {
    var term: String
}

// MARK: - ResponseAutocomplete
struct ResponseAutocomplete: Codable {
    let airports: [Airport]?
    let term: String?
    let limit: Int?
    let size: Int?
    let cached, status: Bool?
    let statusCode: Int?
}

// MARK: - Airport
struct Airport: Codable {
    let name: String
    let city: String
    let iata: String
    let country: Country
    let state: State
}

// MARK: - Country
struct Country: Codable {
    let name: String
    let iso: String
}

// MARK: - State
struct State: Codable {
    let name: String
    let abbr: String?
}



class IATACodesApi {
    private let APC_AUTH: String = "5f9aa8ce10"
    private let APC_AUTH_SECRET: String = "44afc30e891ab7d"
    
    private let host: String = "https://www.air-port-codes.com/api/v1"
    private let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    
    init() {}
    
    public func autocomplete(_ body: RequestAutocomplete) {
        print(body)
        let endpoint = "\(host)/autocomplete"
        let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        do {

            guard let endpointSafeURL = URL(string: safeURLString!) else {
                print("There is a error with endpintUrl")
                return
           }

            var request = URLRequest(url: endpointSafeURL)
            request.httpMethod = "POST"

           
            // Set HTTP Request Header
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(APC_AUTH,           forHTTPHeaderField: "APC-Auth")
            request.setValue(APC_AUTH_SECRET,    forHTTPHeaderField: "APC-Auth-Secret")
          
//          MARK: - Temporary
            let parameters: [String: Any] = [ "term": "Napo" ]
          
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                guard let jsonData = data else {
                    print("The playload is invalid")
                    return
                }
              
                let decodedData = Data(base64Encoded: jsonData.base64EncodedString())!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                
                print(decodedString)
                let decoder = JSONDecoder()
                
                do {
                    let responseData = try decoder.decode(ResponseAutocomplete.self, from: jsonData);
                    print("JSON decoded")
                    print(responseData)
                    
                    // USE THE LOADED DATA HERE
                    
                } catch let error {
                    print("JSON decoding failed \(error)")
                }
            }

            dataTask.resume()
            
        } catch {
            print("weather JSON decoding failed \(error)")
        }

        
       
    }
    
}

// MARK: - Only for palyground

//let iataCodes = IATACodes()
//let body = RequestAutocomplete(term: "Napo")
//iataCodes.autocomplete(body)
