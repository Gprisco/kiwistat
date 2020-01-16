//
//  Home.swift
//  kiwistat
//
//  Created by Antonio Alfonso on 13/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        Section {
                            TextField("From", text: $from)
                                .padding(8)
                            
                            TextField("To", text: $to)
                                .padding(8)
                        }
                    }
                    
                    Button(action: {
                        let temp = self.from
                        self.from = self.to
                        self.to = temp
                    }) {
                        Text("Inverti")
                        
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100, style: .circular)
                            .stroke(lineWidth: 1.0)
                    )
                }
                .padding(15)
                
                DatePicker(selection: self.$date, in: Date()..., displayedComponents: .date, label: { Text("Departure") })
                    .padding(8)
                    .labelsHidden()
                
                NavigationLink(destination: Results(tequilaHandler: Tequila(date_from: self.date, date_to: self.date, fly_from: self.from, fly_to: self.to))) {
                    Text("Submit")
                }
                .padding(8)
            }
            .navigationBarTitle(Text("KiwiStat"))
            .background(Color.clear)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
