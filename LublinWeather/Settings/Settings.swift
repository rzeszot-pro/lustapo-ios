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
                    NavigationLink(destination: Languages(), label: {
                        Text("languages.title")
                    })
                }
                Section {
                    NavigationLink(destination: About(), label: {
                        Text("about.title")
                    })
                    NavigationLink(destination: Info(), label: {
                        Text("info.title")
                    })
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("settings.title")
            .navigationBarItems(leading: close)
        }
    }

    private var close: some View {
        Button(action: dismiss ?? {}, label: {
            Image(systemName: "xmark")
        })
    }

}
