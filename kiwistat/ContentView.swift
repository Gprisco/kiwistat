//
//  ContentView.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 10/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!").onAppear(perform: {
            retriveFavorites()
            saveNewFavoriteFlight()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func retriveFavorites() {
    CKManager.shared.fetchRecords { (flights, error) in
        if !error.isEmpty {
            print(error)
        } else {
            print("Successfully retrived \(flights.count) favorite flights.")
            flights.forEach{ print("\($0.destination), \($0.price)€, \($0.temperature)°C")}
        }
    }
}

func saveNewFavoriteFlight() {
    let flight = FavoriteFlight(destination: "Tokyo", price: 1200, temperature: 32)
    CKManager.shared.saveRecord(favoriteFlight: flight)
}
