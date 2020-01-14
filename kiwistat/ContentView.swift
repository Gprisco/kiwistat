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

struct Tickes: View {
    var body: some View {
        
        Text("Tickes, World!")
    }
}


struct ContentView: View {
    @State private var selection = 1
    
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            Home().tabItem {
                Image(systemName: "1.square.fill")
                Text("First")
            }.padding(16)
            
           Tickes().tabItem {
               Image(systemName: "2.square.fill")
               Text("Second")
           }
            
       }.accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func retriveFavorites() {
    CKManager.shared.fetchRecords { (flights, error) in
        if !error.isEmpty {
            print(error)
        } else {
            print("Successfully retrived \(flights.count) favorite flights.")
            flights.forEach{ print("\($0.destination), \($0.price)€, \($0.temperature)°C")}
        }
    }
}

func saveNewFavoriteFlight() {
    let flight = FavoriteFlight(destination: "Tokyo", price: 1200, temperature: 32)
    CKManager.shared.saveRecord(favoriteFlight: flight)
}
