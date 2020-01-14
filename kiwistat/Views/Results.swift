//
//  Results.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 14/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Results: View {
    @State var flights: [Flight]? = nil
    
    var date_from: Date
    var date_to: Date
    var fly_from: String
    var fly_to: String
    
    var body: some View {
        NavigationView {
            if(self.flights != nil) {
                List() {
                    Text("Hi")
                }
            }
            else {
                Text("No data")
            }
        }.onAppear(perform: {
            let tequilaHandler = Tequila()
            
            tequilaHandler.getFlights(
                date_from: self.date_from,
                date_to: self.date_to,
                fly_from: self.fly_from,
                fly_to: self.fly_to,
                completion: { (flights, error) in
                    self.flights = flights?.data ?? nil
                }
            )
        })
    }
}

struct Results_Previews: PreviewProvider {
    static var previews: some View {
        Results(date_from: Date(), date_to: Date(timeIntervalSinceNow: 60 * 60 * 24 * 15), fly_from: "NAP", fly_to: "PRG")
    }
}
