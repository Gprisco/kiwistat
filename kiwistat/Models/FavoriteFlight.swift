//
//  Flight.swift
//  kiwistat
//
//  Created by Samuel Kebis on 12/01/2020.
//  Copyright © 2020 Samuel Kebis. All rights reserved.
//

import UIKit
import CloudKit

class FavoriteFlight: Identifiable {
    
    var id = UUID()
    var link: String
    var destination: String
    var departure: String
    var iconName: String
    var price: Int
    
    init(link: String, destination: String, departure: String, iconName: String, price: Int) {
        self.destination = destination
        self.link = link
        self.departure = departure
        self.iconName = iconName
        self.price = price
    }
    
    convenience init?(record: CKRecord) {
        guard
            let destination = record["destination"] as? String,
            let link = record["link"] as? String,
            let departure = record["departure"] as? String,
            let iconName = record["iconName"] as? String,
            let price = record["price"] as? Int
            else { return nil }
        
        self.init(link: link, destination: destination, departure: departure, iconName: iconName, price: price)
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "NewFavoriteFlight")
        record["destination"] = destination
        record["link"] = link
        record["departure"] = departure
        record["iconName"] = iconName
        record["price"] = price
        return record
    }
}
