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
            Row(key: "data.temperature", value: String(payload.temperature ?? 0), unit: "°C")
            Row(key: "data.wind-speed", value: String(payload.windspeed ?? 0), unit: "km/h")
            Row(key: "data.pressure", value: String(payload.pressure ?? 0), unit: "hPa")
            Row(key: "data.rain", value: String(payload.rain ?? 0), unit: "mm")

            DateProperty(date: payload.date)
        }
    }

    // MARK: -

    struct DateProperty: View {
        var date: Date

        var text: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }

        var body: some View {
            Row(key: "data.updated", value: text)
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
