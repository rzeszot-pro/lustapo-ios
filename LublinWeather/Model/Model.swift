//
//  Model.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI


class Model: ObservableObject {

    var regions: [Region]

    @State
    var active: String?

    // MARK: -

    init(regions: [Region], active: String?) {
        self.regions = regions
//        self.active = active
    }

    // MARK: -

    var stations: [Station] {
        regions.flatMap { $0.stations }
    }

    // MARK: -

    static var standard: Model {
        Database().load()
    }

}
