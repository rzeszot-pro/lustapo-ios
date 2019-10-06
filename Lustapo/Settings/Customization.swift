//
//  Customization.swift
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
import Combine

struct Customization: View {

    @EnvironmentObject
    var location: Location

    @ObservedObject
    var show = UserDefaults.show_instance

    @ObservedObject
    var shown = UserDefaults.ask_shown

    var body: some View {
        List {
            Section {
                Distance()
            }

            #if DEBUG
            Section {
                HStack {
                    Text("Status")
                    Spacer()
                    Text(location.status.description)
                }
                HStack {
                    Text("Ask shown")
                    Spacer()
                    Text(String(describing: shown))
                }
                HStack {
                    Text("Show distance")
                    Spacer()
                    Text(String(describing: show))
                }
            }
            #endif
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("customization.title")
    }

    // MARK: -

    struct Distance: View {

        @ObservedObject
        var location: Location = .shared

        @ObservedObject
        var distance = UserDefaults.show_instance

        @State
        var ask: Bool = false

        var body: some View {
            Toggle(isOn: Binding<Bool>(get: { self.distance.get() == true && self.location.authorized }, set: show), label: { Text("customization.show-distance") })
                .alert(isPresented: $ask, content: { Alert.redirect(action: settings) })
        }

        func show(_ value: Bool) {
            guard value else {
                distance.set(false)
                return
            }

            switch location.status {
            case .notDetermined:
                distance.set(true)
                location.request()
            case .authorizedWhenInUse, .authorizedAlways:
                distance.set(true)
            case .denied:
                ask = true
            default:
                print("other")
            }

            location.objectWillChange.send()
        }

        func settings() {
            UIApplication.shared.open(.settings, options: [:]) { success in
                if !success {
                    // TODO: report failure
                }
            }
        }
    }

}

extension Alert {
    static func redirect(action: @escaping () -> Void) -> Alert {
        Alert(title: Text("permission.alert.title"), message: Text("permission.alert.message"), primaryButton: .default(Text("permission.alert.goto"), action: action), secondaryButton: .cancel())
    }
}
