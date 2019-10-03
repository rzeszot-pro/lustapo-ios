//
//  Database.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation

struct Database {

    func load() -> Model {
        let url = Bundle.main.url(forResource: "database", withExtension: "json")!
        let data = try! Data(contentsOf: url)

        let stations = try! JSONDecoder().decode([Station].self, from: data)

        let lublin = stations.filter { $0.name.starts(with: "Lublin - ") }
        let other = stations.filter { !$0.name.starts(with: "Lublin - ") }

        let regions = [
            Region(name: "Lublin", stations: lublin),
            Region(name: "Other", stations: other)
        ]

        return Model(regions: regions, active: "Lublin - Plac Litewski i wieża")
    }

}

