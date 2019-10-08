//
//  Database.swift
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

import Foundation

struct Database {

    var last = UserDefaults.last_station

    var url: URL {
        Bundle.main.url(forResource: "database", withExtension: "json")!
    }

    // swiftlint:disable force_try
    var stations: [Station] {
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()

        return try! decoder.decode([Station].self, from: data)
    }

    func load() -> Model {
        func condition(_ station: Station) -> Bool {
            station.name.starts(with: "Lublin - ")
        }

        let lublin = stations.select(condition)
        let other = stations.reject(condition)

        let lastStationId = last.get()
        let active = stations.first { $0.id == lastStationId } ?? stations[0]
        let regions = [
            Region(name: "Lublin", stations: lublin),
            Region(name: "Other", stations: other)
        ]

        return Model(regions: regions, station: active)
    }

}

extension Array {
    func select(_ condition: (Element) -> Bool) -> Array {
        filter(condition)
    }

    func reject(_ condition: (Element) -> Bool) -> Array {
        filter { !condition($0) }
    }
}
