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
        NavigationView {
            if !(self.tequilaHandler.response.isEmpty) {
                VStack {
                    List(self.tequilaHandler.response) { data in
                        VStack {
                            HStack {
                                Text("✈ \(data.flight.airlines[0])")
                                Spacer()
                                URLImage(url: "https://www.weatherbit.io/static/img/icons/\(data.weather[0].weather.icon).png")
                                Spacer()
                                Text("€ \(data.flight.price)")
                            }.padding(15)
                            
                            ForEach(data.flight.route) { route in
                                HStack {
                                    Text(route.cityFrom)
                                    Spacer()
                                    Text("✈")
                                    Spacer()
                                    Text(route.cityTo)
                                }.padding(15)
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
                        Text("Next Page")
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
            .onDisappear(perform: { self.tequilaHandler.response = [FetchedData]() })
    }
}

struct Results_Previews: PreviewProvider {
    static var previews: some View {
        Results(tequilaHandler: Tequila(date_from: Date(), date_to: Date(), fly_from: "NAP", fly_to: "PRG"))
    }
}
