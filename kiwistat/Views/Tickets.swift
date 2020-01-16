//
//  Tickets.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 14/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Tickets: View {
    @State var savedTickets = [FavoriteFlight]()
    
    var body: some View {
        NavigationView {
            VStack {
                if savedTickets.count > 0 {
                    List(savedTickets) { savedTicket in
                        Button(action: {
                            let url: NSURL = URL(string: savedTicket.link)! as NSURL
                            
                            UIApplication.shared.open(url as URL)
                        }) {
                            HStack {
                                Text("\(savedTicket.departure) - \(savedTicket.destination)")
                                Spacer()
                                URLImage(url: "https://www.weatherbit.io/static/img/icons/\(savedTicket.iconName).png")
                                Spacer()
                                Text("€ \(savedTicket.price)")
                            }
                        }
                    }
                } else {
                    Text("No data")
                }
            }
            .onAppear(perform: {
                let cloudKitManager = CKManager()
                
                cloudKitManager.fetchRecords(completion: { data, error in
                    if error == "" {
                        DispatchQueue.main.async {
                            self.savedTickets = data
                        }
                    }
                })
            })
            .navigationBarTitle(Text("Saved Flights"))
        }
    }
}

struct Tickets_Previews: PreviewProvider {
    static var previews: some View {
        Tickets()
    }
}
