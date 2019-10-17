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

    var service: FeedbackService = FeedbackService()

    @State
    var email: String = ""

    @State
    var details: String = ""

    @State
    var height: CGFloat = 0

    @State
    var sending: Bool = false

    @State
    var alert: Bool = false

    // MARK: -

    var deviceModel: String {
        UIDevice.name(from: UIDevice.current.modelCode ?? "unknown") ?? UIDevice.current.modelCode ?? UIDevice.current.model
    }

    var systemVersion: String {
        UIDevice.current.systemName + " " + UIDevice.current.systemVersion
    }

    var appVersion: String {
        (Bundle.main.name ?? "") + " " + (Bundle.main.version ?? "")
    }

    // MARK: -

    var body: some View {
        List {
            Section {
                Row(key: "Device model", value: deviceModel)
                Row(key: "System", value: systemVersion)
                Row(key: "App version", value: appVersion)
            }
            Section(header: Text("feedback.email")) {
                TextField("", text: self.$email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }
            Section(header: Text("feedback.details")) {
                TextView(text: self.$details, contentHeight: self.$height)
                    .frame(height: max(self.height, 50))
            }
        }
        .modifier(KeyboardAdaptive())
        .navigationBarTitle("feedback.title")
        .navigationBarItems(trailing: Loading(loading: sending, view: SendButton(action: send).disabled(details.isEmpty)))
        .onAppear(perform: load)
        .onDisappear(perform: store)
        .alert(isPresented: $alert) {
            Alert(title: Text("feedback.sent"))
        }
        .modifier(LifeCycleAnalytics(id: "feedback"))
    }

    // MARK: -

    let defaults = UserDefaults.standard

    func load() {
        email = defaults.string(forKey: "feedback.email") ?? ""
        details = defaults.string(forKey: "feedback.details") ?? ""
    }

    func store() {
        defaults.set(email, forKey: "feedback.email")
        defaults.set(details, forKey: "feedback.details")
    }

    func send() {
        sending = true

        service.send(email: email, details: details) { success in
            if success {
                self.email = ""
                self.details = ""
            }

            self.sending = false
            self.alert = true

            collector.track("feedback.send", params: ["success": success])
        }
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
            Button(action: action, label: {
                Image(systemName: "paperplane")
                    .padding(5)
            })
        }
    }

}
