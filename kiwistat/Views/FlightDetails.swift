//
//  FlightDetails.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 16/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct FlightDetails: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var details: FetchedData
    
    var body: some View {
        VStack {
            List {
                VStack(alignment: .leading) {
                    Text("Flight Info")
                        .font(.headline)
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    
                    HStack {
                        Text("✈ \(details.flight.airlines[0])")
                        URLImage(url: "https://www.weatherbit.io/static/img/icons/\(details.weather[0].weather.icon).png")
                        Text("€ \(details.flight.price)")
                    }.padding(15)
                    
                    Text("\(details.weather[0].datetime)")
                    
                    ForEach(details.flight.route) { route in
                        HStack {
                            VStack {
                                Text(route.cityFrom)
                                Text(route.local_departure.iso8601Date!.isoToTimeString)
                                    .font(.caption)
                            }
                            Spacer()
                            Text("✈")
                            Spacer()
                            VStack {
                                Text(route.cityTo)
                                Text(route.local_arrival.iso8601Date!.isoToTimeString)
                                    .font(.caption)
                            }
                        }.padding(15)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Weather Info")
                        .font(.headline)
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(details.weather, id: \.id) { weather in
                                VStack {
                                    URLImage(url: "https://www.weatherbit.io/static/img/icons/\(weather.weather.icon).png")
                                    Text("\(Int(weather.temp)) °C")
                                    Text(weather.datetime.dayMonth)
                                }
                                .padding()
                            }
                        }
                    }
                    .frame(height: 185)
                }
            }
            .navigationBarTitle(Text("\(details.flight.cityFrom) - \(details.flight.cityTo)"))
            .navigationBarItems(trailing: Button(action: {
                let cloudKitManager = CKManager()
                
                cloudKitManager.saveRecord(favoriteFlight: FavoriteFlight(
                    link: self.details.flight.deep_link,
                    destination: self.details.flight.cityTo,
                    departure: self.details.flight.cityFrom,
                    iconName: self.details.weather[0].weather.icon,
                    price: self.details.flight.price)
                )
                
                self.mode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
            
            Button(action: {
                let url: NSURL = URL(string: self.details.flight.deep_link)! as NSURL
                
                UIApplication.shared.open(url as URL)
            }) {
                Text("Book Now")
            }
            .padding(15)
        }
    }
}
