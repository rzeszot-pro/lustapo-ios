//
//  Dashboard.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI


struct Properties: View {

    var payload: Payload

    var body: some View {
        Section {
            if payload.temperature_air != nil {
                Row(key: "data.temperature-air", value: String(payload.temperature_air!), unit: "°C")
            }

            if payload.temperature_ground != nil {
                Row(key: "data.temperature-ground", value: String(payload.temperature_ground!), unit: "°C")
            }

            if payload.temperature_sense != nil {
                Row(key: "data.temperature-sense", value: String(payload.temperature_sense!), unit: "°C")
            }

            if payload.wind_direction != nil || payload.wind_speed != nil {
                WindProperty(speed: payload.wind_speed, direction: payload.wind_direction)
            }

            if payload.humidity != nil {
                Row(key: "data.humidity", value: String(payload.humidity!), unit: "%")
            }

            if payload.pressure != nil {
                Row(key: "data.pressure", value: String(payload.pressure!), unit: "hPa")
            }

            if payload.rain != nil {
                Row(key: "data.rain", value: String(payload.rain!), unit: "mm")
            }

            DateProperty(date: payload.date)
        }
    }

    // MARK: -

    struct WindProperty: View {
        var speed: Double?
        var direction: Double?

        var text: String? {
            guard let value = direction else { return nil }

            if value <= 22 || value >= 338 {
                return "N"
            } else if value <= 67 {
                return "NE"
            } else if value <= 112 {
                return "E"
            } else if value <= 157 {
                return "SE"
            } else if value <= 202 {
                return "S"
            } else if value <= 247 {
                return "SW"
            } else if value <= 292 {
                return "W"
            } else if value <= 337 {
                return "NW"
            } else {
                return nil
            }
        }

        var body: some View {
            HStack {
                Text(LocalizedStringKey("data.wind"))
                    .foregroundColor(Color.primary)
                    .font(.body)

                Spacer()

                if text != nil {
                    Text(String(text!))
                        .foregroundColor(Color.primary)
                        .font(.headline)

                    if speed != nil {
                        Text(verbatim: "|")
                            .foregroundColor(Color.secondary)
                    }
                }

                if speed != nil {
                    Text(String(speed!))
                        .foregroundColor(Color.primary)
                        .font(.headline)
                    Text(verbatim: "km/h")
                        .foregroundColor(Color.secondary)
                        .font(.caption)
                }
            }
        }
    }
    

    struct DateProperty: View {
        var date: Date

        var text: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }

        var obsolete: Bool {
            date.timeIntervalSinceNow < -20 * 60
        }

        var body: some View {
            Row(key: "data.updated", value: text)
                .listRowBackground(obsolete ? Color.obsolete : nil)
        }
    }

    struct Row: View {
        var key: String
        var value: String
        var unit: String? = nil

        var body: some View {
            HStack {
                Text(LocalizedStringKey(key))
                    .foregroundColor(Color.primary)
                    .font(.body)
                Spacer()
                Text(value)
                    .foregroundColor(Color.primary)
                    .font(.headline)

                if unit != nil {
                    Text(unit!)
                        .foregroundColor(Color.secondary)
                        .font(.caption)
                }
            }
        }
    }

}


private extension Color {
    static let obsolete = Color("obsolete")
}
