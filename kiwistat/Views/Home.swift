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
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Text("KiwiStat")
                        .fontWeight(.bold)
                        .font(.title)
                }
                
                HStack {
                    VStack {
                        TextField("From", text: $from)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                        )
                        
                        TextField("To", text: $to)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                        )
                        
                    }
                    
                    VStack {
                        Button(action: {
                            let temp = self.from
                            self.from = self.to
                            self.to = temp
                            
                            // MARK: - Temporary
                            print("iataCodes")
                            let iataCodes = IATACodes()
                            print("iataCodes")
                            let body = RequestAutocomplete(term: "Napo")
                            iataCodes.autocomplete(body)
                            
                        }) {
                            Text("Inverti")
                            
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                            
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }.padding(8)
                }
                
                NavigationLink(destination: Results(tequilaHandler: Tequila(date_from: Date(), date_to: Date(timeIntervalSinceNow: 3600 * 24 * 15), fly_from: self.from, fly_to: self.to))) {
                    Text("Submit")
                    
                    
                }
            }.padding(16)
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
