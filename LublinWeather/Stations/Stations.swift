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

    var select: (() -> Void)?

    var body: some View {
        NavigationView {
            List {
                ForEach(model.regions) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.stations) { station in
                            Row(select: {
                                self.model.active = station.name
                                self.select?()
                            }, station: station, selected: self.model.active == station.name)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("stations.title")
            .navigationBarItems(leading: close)
        }
    }

    // MARK: -

    private var close: some View {
        Button(action: select ?? {}, label: {
            Image(systemName: "xmark")
        })
    }

    // MARK: -

    struct Row: View {
        var select: (() -> Void)?

        var station: Station
        var selected: Bool

        var body: some View {
            HStack {
                Button(action: select ?? {}, label: {
                    Text(station.name)
                })
                Spacer()

                if selected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }

}
