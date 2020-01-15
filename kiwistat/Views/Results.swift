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
    
    var body: some View {
        NavigationView {
            if(self.tequilaHandler.response.data != nil) {
                List(self.tequilaHandler.response.data!) { flight in
                    VStack {
                        Text(flight.airlines[0])
                            ForEach(flight.route) { route in
                                HStack {
                                    Text(route.cityFrom)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                    Spacer()
                                    Text(route.cityTo)
                                }.padding(15)
                            }
                        
                    }
                }
                .navigationBarTitle("Search Result")
            }
            else {
                Text("No data")
            }
        }
    }
}

struct Results_Previews: PreviewProvider {
    static var previews: some View {
        Results(tequilaHandler: Tequila(date_from: Date(), date_to: Date(timeIntervalSinceNow: 3600 * 24 * 15), fly_from: "NAP", fly_to: "PRG"))
    }
}
