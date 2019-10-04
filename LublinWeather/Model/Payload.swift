//
//  Payload.swift
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


struct Payload: Decodable {
    let date: Date

    let temperature_air: Double?
    let temperature_sense: Double?
    let temperature_ground: Double?

    let wind_speed: Double?
    let wind_direction: Double?

    let humidity: Double?
    let pressure: Double?
    let rain: Double?

    // MARK: - Decodable

    private enum Key: String, CodingKey {
        case data

        case temperature_ground = "T5"
        case temperature_air = "temperatureInt"
        case temperature_sense = "windChillInt"

        case wind_dir_a = "windDirInt"
        case wind_dir_b = "windDir"

        case wind_speed_a = "windSpeedInt"
        case wind_speed_b = "windSpeed"

        case humidity = "humidityInt"
        case pressure = "pressureInt"
        case rain = "rainT"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        guard let date = DateFormatter.remote.date(from: try container.decode(String.self, forKey: .data)) else { throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "invalid date encoding")}

        self.date = date

        temperature_air = try container.decodeIfPresent(Double.self, forKey: .temperature_air)
        temperature_sense = try container.decodeIfPresent(Double.self, forKey: .temperature_sense)
        temperature_ground = try container.decodeIfPresent(Double.self, forKey: .temperature_ground)

        wind_direction = try container.decodeIfPresent(Double.self, forKeys: [.wind_dir_a, .wind_dir_b])
        wind_speed = try container.decodeIfPresent(Double.self, forKeys: [.wind_speed_a, .wind_speed_b])

        humidity = try container.decodeIfPresentAndNotString(Double.self, forKey: .humidity)
        pressure = nullify(try container.decodeIfPresent(Double.self, forKey: .pressure))
        rain = try container.decodeIfPresent(Double.self, forKey: .rain)
    }
}

private func nullify(_ value: Double?) -> Double? {
    guard let value = value else { return nil }
    return value == 0 ? nil : value
}

private extension DateFormatter {
    static var remote: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}

private extension KeyedDecodingContainer {

    func decodeIfPresentAndNotString<T: Decodable>(_ type: T.Type, forKey key: Self.Key) throws -> T? {
        if let value = try? decodeIfPresent(String.self, forKey: key) {
            if value == "" {
                return nil
            }
        }

        return try decodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKeys keys: [Self.Key]) throws -> T? {
        for key in keys {
            guard let value = try decodeIfPresentAndNotString(type, forKey: key) else { continue }
            return value
        }

        return nil
    }
}
