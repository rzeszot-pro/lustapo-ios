//
//  WeatherStation.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 16/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

// swiftlint:disable variable_name

import Foundation



struct WeatherStation {
    let name: String
    let endpoint: String
}



extension WeatherStation: Equatable {}

func == (lhs: WeatherStation, rhs: WeatherStation) -> Bool {
    return lhs.endpoint == rhs.endpoint && lhs.name == rhs.name
}
