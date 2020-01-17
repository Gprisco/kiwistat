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

struct ContentView: View {
    @State private var selection = 0 
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
            }
            .tag(0)
            
            Tickets()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
            }
        .tag(1)
        }.accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
