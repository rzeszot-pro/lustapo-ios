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

        let model: String
        let system: String
    }

    var data: Data = .init()

    var body: some View {
        List {
            Section(header: Text("about.app")) {
                Row(key: "about.app.version", value: data.version)
                Row(key: "about.app.build", value: data.build)
            }
            Section(header: Text("about.device")) {
                Row(key: "about.device.model", value: data.model)
                Row(key: "about.device.system", value: data.system)
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

    init(bundle: Bundle, device: UIDevice) {
        version = bundle.version ?? ""
        build = bundle.build ?? ""

        model = device.model
        system = [device.systemName, device.systemVersion].joined(separator: " ")
    }

    init() {
        self.init(bundle: .main, device: .current)
    }

}
