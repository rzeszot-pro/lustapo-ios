//
//  Distance.swift
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

struct Distance: View {

    @ObservedObject
    var location: Location = .shared

    @ObservedObject
    var distance = UserDefaults.show_instance

    @State
    var ask: Bool = false

    var binding: Binding<Bool> {
        .init(get: { self.distance.get() == true && self.location.authorized }, set: toggle)
    }

    var body: some View {
        Toggle(isOn: binding, label: { Text("distance.show") })
            .alert(isPresented: $ask, content: { Alert.redirect(action: settings) })
    }

    func toggle(_ value: Bool) {
        if value {
            enable()
        } else {
            disable()
        }
    }

    func enable() {
        switch location.status {
        case .notDetermined:
            distance.set(true)
            location.request()
        case .authorizedWhenInUse, .authorizedAlways:
            distance.set(true)
        case .denied, .restricted:
            ask = true
        default:
            // TODO: report it
            print("other")
        }

        location.objectWillChange.send()
    }

    func disable() {
        distance.set(false)
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

extension Alert {
    static func redirect(action: @escaping () -> Void) -> Alert {
        Alert(title: Text("distance.alert.title"), primaryButton: .default(Text("distance.alert.goto"), action: action), secondaryButton: .cancel())
    }
}
