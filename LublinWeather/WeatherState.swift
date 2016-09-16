//
//  Model.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 22/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//


// swiftlint:disable variable_name


import Foundation



struct WeatherState {
	let temperature: NSDecimalNumber?
	let date: String?
	let pressure: NSDecimalNumber?
	let windSpeed: NSDecimalNumber?
	let rain: NSDecimalNumber?
}



private func convertNSNumberToNSDecimalNumber(value: NSNumber?) -> NSDecimalNumber? {
    if let v = value {
        return NSDecimalNumber(decimal: v.decimalValue)
    }
    return nil
}

extension WeatherState {

    init(json: JSONDictionary) {
        temperature = convertNSNumberToNSDecimalNumber(json.get("temperatureInt"))
        date = json.get("data")
        pressure = convertNSNumberToNSDecimalNumber(json.get("pressureInt"))

        let windSpeed = convertNSNumberToNSDecimalNumber(json.get("windSpeedInt"))
        if windSpeed != nil {
            self.windSpeed = windSpeed
        } else {
            self.windSpeed = convertNSNumberToNSDecimalNumber(json.get("windSpeed"))
        }

        let rain = convertNSNumberToNSDecimalNumber(json.get("rainCumInt"))
        if rain != nil {
            self.rain = rain
        } else {
            self.rain = convertNSNumberToNSDecimalNumber(json.get("rainT"))
        }
    }

}
