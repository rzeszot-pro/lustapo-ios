//
//  Payload.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation


struct Payload: Decodable {
    let date: Date
    let temperature: Double?
    let pressure: Double?
    let windspeed: Double?
    let rain: Double?

    // MARK: - Decodable

    private enum Key: String, CodingKey {
        case data
        case temperature = "temperatureInt"
        case pressure = "pressureInt"
        case windspeedA = "windSpeedInt"
        case windspeedB = "windSpeed"
        case rainA = "rainCumInt"
        case rainB = "rainT"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        guard let date = DateFormatter.remote.date(from: try container.decode(String.self, forKey: .data)) else { throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "invalid date encoding")}

        self.date = date
        self.temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        self.pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        self.windspeed = try container.decodeIfPresent(Double.self, forKeys: [.windspeedA, .windspeedB]) // normalize * 3.6
        self.rain = try container.decodeIfPresent(Double.self, forKeys: [.rainA, .rainB])
    }
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
    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKeys keys: [Self.Key]) throws -> T? {
        for key in keys {
            guard let value = try decodeIfPresent(type, forKey: key) else { continue }
            return value
        }

        return nil
    }
}
