//
//  Flight.swift
//  kiwistat
//
//  Created by Samuel Kebis on 12/01/2020.
//  Copyright © 2020 Samuel Kebis. All rights reserved.
//

import UIKit
import CloudKit

class FavoriteFlight {
    var destination: String
    var price: Int
    var temperature: Double
    
    init(destination: String, price: Int, temperature: Double) {
        self.destination = destination
        self.price = price
        self.temperature = temperature
    }
    
    convenience init?(record: CKRecord) {
        guard
            let d = record["destination"] as? String,
            let p = record["price"] as? Int,
            let t = record["temperature"] as? Double
            else { return nil }
        
        self.init(destination: d, price: p, temperature: t)
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "FavoriteFlight")
        record["destination"] = destination
        record["price"] = price
        record["temperature"] = temperature
        return record
    }
}
