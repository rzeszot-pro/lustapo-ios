//
//  Permissions.swift
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

struct Permissions: View {

    @EnvironmentObject
    var location: Location

    @UserDefault(key: "ask-shown")
    var shown: Bool = false

    var body: some View {
        List {
            debug
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("permissions.title")
    }

    var debug: some View {
        Section {
            Row(key: Text("Status"), value: Text(location.status.description))
            Toggle(isOn: Binding(_shown), label: { Text("Shown") })
        }
    }

    // MARK: -

    struct Row<Key: View, Value: View>: View {
        var key: Key
        var value: Value

        var body: some View {
            HStack {
                key
                Spacer()
                value
            }
        }
    }

}
