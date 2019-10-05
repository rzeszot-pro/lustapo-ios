//
//  SceneDelegate.swift
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

import SwiftUI

struct Main: View {

    enum Subview: String, Identifiable {
        case settings
        case selection
    }

    @EnvironmentObject
    var model: Model

    @State
    var subview: Subview?

    var body: some View {
        NavigationView {
            List {
                Section {
                    StationButton(station: model.station, action: selection)
                }
                Section {
                    IfLet(model.measurements.data?.temperature.air) { Properties.Temperature(air: $0) }
                    IfLet(model.measurements.data?.temperature.ground) { Properties.Temperature(ground: $0) }
                    IfLet(model.measurements.data?.temperature.sense) { Properties.Temperature(sense: $0) }

                    if model.measurements.data?.wind.direction != nil || model.measurements.data?.wind.speed != nil {
                        Properties.Wind(speed: model.measurements.data?.wind.speed, direction: model.measurements.data?.wind.direction)
                    }

                    IfLet(model.measurements.data?.humidity) { Properties.Humidity(value: $0) }
                    IfLet(model.measurements.data?.pressure) { Properties.Pressure(value: $0) }
                    IfLet(model.measurements.data?.rain) { Properties.Rain(value: $0) }

                    IfLet(model.measurements.data?.date) { value in Properties.Updated(date: value) }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("app.title")
            .navigationBarItems(leading: SettingsButton(action: settings), trailing: model.measurements.loading ? AnyView(ActivityIndicator()) : AnyView(ReloadButton(action: model.reload)))
            .sheet(item: $subview, content: sheet)
            .onAppear(perform: model.reload)
        }
    }

    // MARK: -

    struct StationButton: View {
        var station: Station
        var action: () -> Void
        var body: some View {
            Button(action: action, label: {
                Text(station.name)
            })
        }
    }

    struct SettingsButton: View {
        var action: () -> Void
        var body: some View {
            Button(action: action, label: {
                Image(systemName: "gear")
            })
        }
    }

    struct ReloadButton: View {
        var action: () -> Void
        var body: some View {
            Button(action: action, label: {
                Image(systemName: "arrow.2.circlepath")
            })
        }
    }

    // MARK: -

    func settings() {
        subview = .settings
    }

    func selection() {
        subview = .selection
    }

    func dismiss() {
        subview = nil
    }

    func sheet(_ id: Subview) -> some View {
        switch id {
        case .settings:
            return AnyView(Settings(dismiss: self.dismiss))
        case .selection:
            return AnyView(Stations(regions: self.model.regions, active: self.model.station, select: { station in
                self.model.station = station
                self.subview = nil
            }, cancel: self.dismiss))
        }
    }

}

private struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .medium)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}
