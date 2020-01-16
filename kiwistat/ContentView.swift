//
//  ContentView.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 10/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

// https://dribbble.com/shots/5951816-Flight-Ticket-Booking-App?utm_source=Pinterest_Shot&utm_campaign=jituraut&utm_content=Flight%20Ticket%20Booking%20App&utm_medium=Social_Share

import SwiftUI

func width(num: CGFloat) -> CGFloat {
    return (UIScreen.main.bounds.width / 12) * num
}

func height(num: CGFloat) -> CGFloat {
    return (UIScreen.main.bounds.height / 12) * num
}

struct ContentView: View {
    @State private var selection = 0 
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
            }
            .tag(0)
            
            Tickets()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
            }
        .tag(1)
        }.accentColor(.green).onAppear{
            // uncomment following to save
//            saveNewFavoriteFlight(fetchedData: <#T##FetchedData#>)
            retrieveFavorites { flights in
                print("__Fetched \(flights.count) flights.")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func retrieveFavorites(completion: @escaping ([FavoriteFlight]) -> Void) {
    CKManager.shared.fetchRecords { (flights, error) in
        if !error.isEmpty {
            print(error)
        } else {
            print("Successfully retrived \(flights.count) favorite flights.")
            flights.forEach{ print("__ \($0.destination), \($0.departure), \($0.link), \($0.iconName)")}
            completion(flights)
        }
    }
}

func saveNewFavoriteFlight(fetchedData: FetchedData) {
    let f = fetchedData
    let flight = FavoriteFlight(link: f.flight.deep_link, destination: f.flight.countryTo.code, departure: f.flight.local_departure, iconName: f.weather.first?.weather.icon ?? "no icon")
    CKManager.shared.saveRecord(favoriteFlight: flight)
}
