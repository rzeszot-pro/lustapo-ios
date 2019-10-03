//
//  Settings.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI

struct Settings: View {

    var dismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: Text("Języki"), label: {
                        Text("Języki")
                    })
                }
                Section {
                    NavigationLink(destination: Text("O aplikacji"), label: {
                        Text("O aplikacji")
                    })
                    NavigationLink(destination: Info(), label: {
                        Text("Informacje")
                    })
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Ustawienia")
            .navigationBarItems(leading: close)
        }
    }

    private var close: some View {
        Button(action: dismiss ?? {}, label: {
            Image(systemName: "xmark")
        })
    }

}
