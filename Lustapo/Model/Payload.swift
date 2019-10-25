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
// swiftlint:disable identifier_name

import Foundation

struct Payload: Codable {
    let date: Date
    let temperature: Temperature
    let wind: Wind

    let humidity: Double?
    let pressure: Double?
    let rain: Double?

    // MARK: -

    struct Temperature: Codable {
        let air: Double?
        let sense: Double?
        let ground: Double?

        // MARK: - Decodable

        private enum Key: String, CodingKey {
            case ground = "T5"
            case air = "temperatureInt"
            case sense = "windChillInt"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)

            air = try container.decodeIfPresent(Double.self, forKey: .air)
            sense = try container.decodeIfPresent(Double.self, forKey: .sense)
            ground = try container.decodeIfPresent(Double.self, forKey: .ground)
        }
    }

    struct Wind: Codable {
        let speed: Double?
        let direction: Double?

        // MARK: - Decodable

        private enum Key: String, CodingKey {
            case wind_dir_a = "windDirInt"
            case wind_dir_b = "windDir"
            case wind_speed_a = "windSpeedInt"
            case wind_speed_b = "windSpeed"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)

            direction = try container.decodeIfPresent(Double.self, forKeys: [.wind_dir_a, .wind_dir_b])
            speed = try container.decodeIfPresent(Double.self, forKeys: [.wind_speed_a, .wind_speed_b])
        }
    }

    // MARK: - Decodable

    private enum Key: String, CodingKey {
        case data
        case humidity = "humidityInt"
        case pressure = "pressureInt"
        case rain = "rainT"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        date = try container.decode(Date.self, forKey: .data)

        temperature = try decoder.singleValueContainer().decode(Temperature.self)
        wind = try decoder.singleValueContainer().decode(Wind.self)

        humidity = try container.decodeIfPresentAndNotString(Double.self, forKey: .humidity)
        pressure = nullify(try container.decodeIfPresentAndNotString(Double.self, forKey: .pressure))
        rain = try container.decodeIfPresent(Double.self, forKey: .rain)
    }
}

private func nullify(_ value: Double?) -> Double? {
    guard let value = value else { return nil }
    return value == 0 ? nil : value
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
