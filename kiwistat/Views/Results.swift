//
//  Results.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 14/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Results: View {
    @ObservedObject var tequilaHandler: Tequila
    var date = Date()
    
    var body: some View {
        VStack {
            if !(self.tequilaHandler.response.isEmpty) {
                VStack {
                    List() {
                        ForEach(self.tequilaHandler.response.sorted(by: { ($0.weather[0].clouds * $0.flight.price) < ($1.weather[0].clouds * $1.flight.price) }), id: \.id) { data in
                            NavigationLink(destination: FlightDetails(details: data)) {
                                VStack {
                                    HStack {
                                        Text("✈ \(data.flight.airlines[0])")
                                        Spacer()
                                        URLImage(url: "https://www.weatherbit.io/static/img/icons/\(data.weather[0].weather.icon).png")
                                        Spacer()
                                        Text("€ \(data.flight.price)")
                                    }.padding(15)
                                    
                                    Text("\(data.weather[0].datetime)")
                                    
                                    ForEach(data.flight.route) { route in
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
                            }
                        }
                    }
                    .navigationBarTitle(Text("Search Result"))
                    
                    Button(action: {
                        self.tequilaHandler.dateFrom.addTimeInterval(3600 * 24)
                        self.tequilaHandler.dateTo.addTimeInterval(3600 * 24)
                        
                        self.tequilaHandler.fetchFlights(completion: { fetchedData in
                            self.tequilaHandler.response.append(fetchedData)
                        })
                    }) {
                        Text("Get More Flights")
                    }
                    .padding(15)
                }
            }
            else {
                Text("No data")
            }
        }
        .onAppear(perform: {
            self.tequilaHandler.fetchFlights(completion: { fetchedData in
                self.tequilaHandler.response.append(fetchedData)
            })            
        })
    }
}

struct Results_Previews: PreviewProvider {
    static var previews: some View {
        Results(tequilaHandler: Tequila(date_from: Date(timeIntervalSinceNow: 360 * 24), date_to: Date(timeIntervalSinceNow: 3600 * 24), fly_from: "NAP", fly_to: "PRG"))
    }
}
