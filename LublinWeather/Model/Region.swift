//
//  Region.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation


struct Region: Identifiable {
    let name: String
    let stations: [Station]

    var id: String {
        name
    }
}
