//
//  Station.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation


struct Station: Decodable, Identifiable {
    let name: String
    let source: String

    // MARK: - Identifiable

    var id: String {
        name.lowercased()
    }
}

extension Station {
    var endpoint: URL {
        let parts = source.split(separator: "-")
        let version = parts[0] == "0" ? "" : parts[0]

        return URL(string: "http://212.182.4.252/data\(version).php?s=\(parts[1])")!
    }
}
