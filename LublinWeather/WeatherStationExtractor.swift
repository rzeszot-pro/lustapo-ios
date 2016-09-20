//
//  WeatherStationExtractor.swift
//  LublinWeather
//
//  Copyright (c) 2016 Piotr Woloszkiewicz
//  Copyright (c) 2016 Damian Rzeszot
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


class WeatherStationExtractor {

    func extract(json: JSONDictionary) -> WeatherState {
        let temperature = extract(temperature: json)
        let date = extract(date: json)
        let pressure = extract(pressure: json)
        let windSpeed = normalize(windSpeed: extract(windSpeed: json))
        let rain = extract(rain: json)

        return WeatherState(date: date, temperature: temperature, pressure: pressure, windSpeed: windSpeed, rain: rain)
    }


    // MARK: - Helpers

    private func extract(temperature json: JSONDictionary) -> Double? {
        return json["temperatureInt"] as? Double
    }

    private func extract(date json: JSONDictionary) -> NSDate? {
        guard let str = json["data"] as? String else {
            return nil
        }

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = NSLocale(localeIdentifier: "pl_PL")
        formatter.timeZone = .GMT()

        return formatter.dateFromString(str)
    }

    private func extract(pressure json: JSONDictionary) -> Double? {
        return json["pressureInt"] as? Double
    }

    private func extract(rain json: JSONDictionary) -> Double? {
        if let value = json["rainCumInt"] as? Double {
            return value
        }

        if let value = json["rainT"] as? Double {
            return value
        }

        return nil
    }

    private func extract(windSpeed json: JSONDictionary) -> Double? {
        if let value = json["windSpeedInt"] as? Double {
            return value
        }

        if let value = json["windSpeed"] as? Double {
            return value
        }

        return nil
    }

    private func normalize(windSpeed value: Double?) -> Double? {
        guard let value = value else {
            return nil
        }

        return value * 3.6
    }

}
