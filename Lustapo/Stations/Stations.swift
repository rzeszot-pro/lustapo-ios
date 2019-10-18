//
//  Stations.swift
//  Lubelskie Stacje Pogodowe
//
//  Copyright (c) 2016-2019 Damian Rzeszot
//  Copyright (c) 2016 Piotr Woloszkiewicz
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Combine
import SwiftUI
import CoreLocation
import MapKit

struct Stations: View {

    var regions: [Region]
    var active: Station

    var select: (Station) -> Void
    var cancel: () -> Void

    // MARK: -

    @State
    var modal: Bool = false

    // MARK: -

    class Model: ObservableObject {

        @ObservedObject
        var location: Location = .shared

        @ObservedObject
        var show = UserDefaults.show_instance

        @ObservedObject
        var shown = UserDefaults.ask_shown

        @Published
        var visible: Bool = false

        init() {
            visible = !shown.get() && location.status == .notDetermined
        }

        func distance(to coordinates: CLLocationCoordinate2D) -> CLLocationDistance? {
            guard show.get() == true else { return nil }
            return location.location?.distance(from: coordinates)
        }

        func permission(_ success: Bool) {
            if success {
                show.set(true)
                location.request()
            }

            shown.set(true)

            withAnimation {
                self.visible = false
            }
        }
    }

    @ObservedObject
    var model: Model = .init()

    // MARK: -

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if model.visible {
                    Ask(action: model.permission)
                    Divider()
                }

                List {
                    ForEach(regions) { region in
                        Section(header: Text(region.name)) {
                            ForEach(region.stations) { station in
                                Row(select: { self.selected(station) }, station: station, active: station == self.active, distance: self.model.distance(to: station.coordinates))
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("stations.title")
            .navigationBarItems(leading: CloseButton(action: cancel), trailing: MapButton(action: { self.modal = true }))
            .sheet(isPresented: $modal, content: {
                Map(cancel: { self.modal = false }, stations: self.regions.flatMap { $0.stations })
            })
        }
        .modifier(LifeCycleAnalytics(id: "stations"))
    }

    // MARK: -

    func selected(_ station: Station) {
        collector.track("stations.select", params: ["station": station.id])
        select(station)
    }

    // MARK: -

    struct Row: View {
        var select: () -> Void
        var station: Station
        var active: Bool
        var distance: CLLocationDistance?

        var formatter: MKDistanceFormatter = .init()

        var body: some View {
            HStack {
                Button(action: select, label: {
                    Text(station.name)
                        .foregroundColor(.primary)
                })

                IfLet(distance) { value in
                    Text(self.formatter.string(fromDistance: value))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if active {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 10)
        }
    }

    struct MapButton: View {
        var action: () -> Void

        var body: some View {
            Button(action: action, label: {
                Image(systemName: "mappin.and.ellipse")
                    .padding(5)
            })
        }
    }

}
