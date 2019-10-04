//
//  Station.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation


struct Station: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
}
