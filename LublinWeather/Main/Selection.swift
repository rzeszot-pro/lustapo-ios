//
//  Selection.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI


struct Selection: View {

    @EnvironmentObject
    var model: Model

    var select: (() -> Void)?

    var body: some View {
        Section {
            Text("xxx")
            Button(action: select ?? { }, label: { Text("xxx") })
        }
    }

}
