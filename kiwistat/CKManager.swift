//
//  CKManager.swift
//  kiwistat
//
//  Created by Samuel Kebis on 12/01/2020.
//  Copyright © 2020 Samuel Kebis. All rights reserved.
//

import UIKit
import CloudKit

class CKManager {
    static let shared = CKManager()
    let database = CKContainer.default().privateCloudDatabase
    
    /// Escaping flights and error string.
    func fetchRecords (completion: @escaping ([FavoriteFlight], String) -> Void) {
        let query = CKQuery(recordType: "FavoriteFlight", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: CKRecordZone(zoneName: "KiwiStatZone").zoneID) { results, error in
            
            if let _ = error { completion([], "Error"); return }
            
            if let results = results {
                let flights = results.compactMap{ FavoriteFlight(record: $0) }
                completion(flights, "")
            }
        }
    }
}
