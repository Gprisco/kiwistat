//
//  Home.swift
//  kiwistat
//
//  Created by Antonio Alfonso on 13/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct FormData {
    var from: String
    var to: String
    var dateFrom: String
    var dateTo: String
    var travellers: Int
}

struct Home: View {
    @State var formData = FormData(
        from: "",
        to: "",
        dateFrom: "",
        dateTo: "",
        travellers: 0
    )
    @State var showDatePicker = false
    @State var showSecondDatePicker = false
    @State var date = Date()
  
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
                        TextField("From", text: $formData.from)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                        )
                        
                        TextField("To", text: $formData.to)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                        )
                        
                    }
                    
                    VStack {
                        Button(action: {
                            let temp = self.formData.from
                            self.formData.from = self.formData.to
                            self.formData.to = temp
                            
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
                
                HStack {
                  TextField(
                        "Date",
                        text: $formData.dateFrom,
                        onEditingChanged: { (editting) in
                            self.showDatePicker = editting
                        }
                    ).padding(16)
                     .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

                }
              
              VStack {
                if showDatePicker == true {
                  DatePicker("", selection: $date, in: Date()..., displayedComponents: .date)
                    .labelsHidden()
                  
                  Button("Forward") {
                    self.showSecondDatePicker = true
                  }
                }

                if showSecondDatePicker == true {
                    DatePicker("SEcondo", selection: $date, in: Date()..., displayedComponents: .date)
                }

              }.frame(width: width(num: 12), alignment: .center)

                
                NavigationLink(
                    destination: Results(
                        tequilaHandler: Tequila(
                            date_from: Date(),
                            date_to: Date(timeIntervalSinceNow: 3600 * 24 * 15),
                            fly_from: self.formData.from,
                            fly_to: self.formData.to
                        )
                    )
                ) {
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
