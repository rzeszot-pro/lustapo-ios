//
//  SceneDelegate.swift
//  LublinWeather
//
//  Copyright (c) 2016 Piotr Woloszkiewicz
//  Copyright (c) 2016 Damian Rzeszot
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

    @EnvironmentObject
    var model: Model

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: selection, label: {
                        Text(model.station.name)
                    })
                }

                if model.data != nil {
                    Properties(payload: model.data!)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("app.title")
            .navigationBarItems(leading: leading, trailing: reload)
            .sheet(item: $subview) { id in
                if id == .selection {
                    Stations(regions: self.model.regions, active: self.model.station, select: { station in
                        self.model.station = station
                        self.subview = nil
                    }, cancel: self.dismiss)
                } else {
                    Settings(dismiss: self.dismiss).environmentObject(self.model)
                }
            }
            .onAppear(perform: model.reload)
        }
    }

    private var leading: some View {
        Button(action: settings, label: {
            Image(systemName: "gear")
        })
    }

    private var reload: some View {
        VStack {
            if model.isReloading {
                ActivityIndicator()
            } else {
                Button(action: model.reload, label: {
                    Image(systemName: "arrow.2.circlepath")
                })
            }
        }
    }

    // MARK: -

    enum Subview: Identifiable {
        case settings
        case selection

        var id: String {
            switch self {
            case .selection: return "selection"
            case .settings: return "settings"
            }
        }
    }

    @State
    var subview: Subview?

    func settings() {
        subview = .settings
    }

    func selection() {
        subview = .selection
    }

    func dismiss() {
        subview = nil
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
