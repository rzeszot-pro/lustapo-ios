//
//  Settings.swift
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

struct Settings: View {

    var dismiss: () -> Void

    var body: some View {
        NavigationView {
            List {
                Section {
                    Distance()
                }
                Section {
                    Statistics()
                }
                Section {
                    Share()
                }
                Section {
                    Row(text: "feedback.title", destination: Feedback())
                }
                Section {
                    Row(text: "privacy.title", destination: PrivacyView())
                    Row(text: "disclaimer.title", destination: DisclaimerView())
                    Row(text: "about.title", destination: AboutView())
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("settings.title")
            .navigationBarItems(leading: CloseButton(action: dismiss))
        }
        .modifier(LifeCycleAnalytics(id: "settings"))
    }

    // MARK: -

    struct Row<Destination: View>: View {
        var text: String
        var destination: Destination
        var body: some View {
            NavigationLink(destination: destination, label: { Text(LocalizedStringKey(text)) })
        }
    }

    struct Share: View {
        @State
        var show: Bool = false

        var body: some View {
            Button(action: { self.show.toggle() }, label: {
                Text("settings.share")
            })
            .sheet(isPresented: $show, content: {
                ShareView(items: [ URL.lustapo ])
                    .modifier(LifeCycleAnalytics(id: "share"))
            })
        }
    }
}

struct ShareView: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)

        vc.completionWithItemsHandler = { activity, completed, returned, error in
            collector.track("share.completion", params: [
                "activity": activity?.rawValue ?? "none",
                "completed": completed
            ])
        }

        return vc
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareView>) {

    }
}

extension URL {
    static var lustapo: URL {
        "https://apps.apple.com/pl/app/lustapo/id1151483507"
    }
}
