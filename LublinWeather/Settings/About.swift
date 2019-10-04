//
//  About.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI


struct About: View {

    struct Data {
        let version: String
        let build: String
    }

    var data: Data = .init()

    var body: some View {
        List {
            Section(header: Text("about.app")) {
                Row(key: "about.app.version", value: "\(data.version) (\(data.build))")
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("about.title")
    }

    struct Row: View {
        var key: String
        var value: String

        var body: some View {
            HStack {
                Text(LocalizedStringKey(key))
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
                    .foregroundColor(.primary)
            }
        }
    }

}

private extension About.Data {

    init(bundle: Bundle) {
        version = bundle.version ?? ""
        build = bundle.build ?? ""
    }

    init() {
        self.init(bundle: .main)
    }

}
