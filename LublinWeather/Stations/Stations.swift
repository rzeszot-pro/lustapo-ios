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

    var select: (Station) -> Void
    var cancel: () -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(model.regions) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.stations) { station in
                            Row(select: self.select, station: station, isSelected: station.id == self.model.active)
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

    private var dismiss: some View {
        Button(action: cancel, label: {
            Image(systemName: "xmark")
        })
    }

    // MARK: -

    struct Row: View {
        var select: (Station) -> Void
        var station: Station
        var isSelected: Bool

        var body: some View {
            HStack {
                Button(action: {
                    self.select(self.station)
                }, label: {
                    Text(station.name)
                })

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }

}
