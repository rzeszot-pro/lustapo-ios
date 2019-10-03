//
//  Stations.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI

struct Stations: View {

    @EnvironmentObject
    var model: Model

    var dismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            List {
                ForEach(model.regions) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.stations) { station in
                            Text(station.name)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Stacje pogodowe")
            .navigationBarItems(leading: close)
        }
    }

    private var close: some View {
        Button(action: dismiss ?? {}, label: {
            Image(systemName: "xmark")
        })
    }

}
