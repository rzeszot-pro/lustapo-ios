//
//  Stations.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI

struct Stations: View {

    var regions: [Region]
    var active: Station

    var select: (Station) -> Void
    var cancel: () -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(regions) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.stations) { station in
                            Row(select: { self.select(station) }, station: station, active: station == self.active)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("stations.title")
            .navigationBarItems(leading: dismiss)
        }
    }

    // MARK: -

    var dismiss: some View {
        Button(action: cancel, label: {
            Image(systemName: "xmark")
        })
    }

    // MARK: -

    struct Row: View {
        var select: () -> Void
        var station: Station
        var active: Bool

        var body: some View {
            HStack {
                Button(action: select, label: {
                    Text(station.name)
                })

                Spacer()

                if active {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }

}
