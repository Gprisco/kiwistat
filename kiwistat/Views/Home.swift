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
    @State private var date: String = ""
    @State private var traveller: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("WikiStat")
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
                    Button(action: { }) {
                        Text("Inverti")
                        
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                        
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }.padding(8)
            }
            
            HStack {
                VStack {
                    TextField("TravelleDater", text: $date)
                        .padding(Edge.Set.horizontal, 8)
                        .padding(Edge.Set.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                    )
                    
                }
                VStack {
                    TextField("Traveller", text: $traveller)
                        .padding(Edge.Set.horizontal, 8)
                        .padding(Edge.Set.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                    )
                }.frame(width: width(num: 4),alignment: .bottom)
            }
            
        }.padding(16)
    }
}

