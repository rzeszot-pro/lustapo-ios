//
//  Info.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI

struct Info: View {

    var body: some View {
        VStack {
            Text("info.top")

            more
                .padding(.vertical, 20)

            Text("info.bottom")

            Spacer()
        }
        .padding(20)
        .navigationBarTitle("info.title")
    }

    // MARK: -

    private var more: some View {
        Button(action: open, label: {
            Text("info.more")
        })
    }

    private func open() {
        UIApplication.shared.open(URL(string: "https://www.umcs.pl/pl/pogoda-w-regionie,2812.htm")!, options: [:]) { success in
            if !success {
                // TODO: report failure
            }
        }
    }

}
