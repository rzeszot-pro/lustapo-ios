//
//  Feedback.swift
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

struct Feedback: View {

    @State
    var email: String = ""

    @State
    var details: String = ""

    var body: some View {
        GeometryReader { geometry in
            List {
                Section {
                    Row(key: "Device model", value: "iPhone 8+")
                    Row(key: "App version", value: "1.15.0")
                }
                Section(header: Text("feedback.email")) {
                    TextField("", text: self.$email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                }
                Section(header: Text("feedback.details")) {
                    TextField("", text: self.$details)
                }
            }
            .frame(height: geometry.size.height)
        }
        .navigationBarTitle("feedback.title")
        .navigationBarItems(trailing: SendButton(action: send))
    }

    // MARK: -

    func send() {

    }

    // MARK: -

    struct Row: View {
        var key: String
        var value: String

        var body: some View {
            HStack {
                Text(LocalizedStringKey(key))
                Spacer()
                Text(value)
            }
            .foregroundColor(.secondary)
            .font(.body)
        }
    }

    struct SendButton: View {
        var action: () -> Void
        var body: some View {
            HStack {
                Spacer()
                Button(action: action, label: {
                    Image(systemName: "paperplane")
                    .padding(5)
                })
                Spacer()
            }
        }
    }

}
