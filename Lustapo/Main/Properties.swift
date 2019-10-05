//
//  Dashboard.swift
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

import SwiftUI

struct Properties: View {

    var payload: Payload

    var body: some View {
        Section {
            IfLet(payload.temperature.air) { Temperature(air: $0) }
            IfLet(payload.temperature.ground) { Temperature(ground: $0) }
            IfLet(payload.temperature.sense) { Temperature(sense: $0) }

            if payload.wind.direction != nil || payload.wind.speed != nil {
                Wind(speed: payload.wind.speed, direction: payload.wind.direction)
            }

            IfLet(payload.humidity) { Humidity(value: $0) }
            IfLet(payload.pressure) { Pressure(value: $0) }
            IfLet(payload.rain) { Rain(value: $0) }

            Updated(date: payload.date)
        }
    }

    // MARK: -

    struct Temperature: View {
        var number: NumberFormatter = .standard
        var key: String
        var value: Double

        init(air value: Double) {
            self.key = "data.temperature-air"
            self.value = value
        }

        init(ground value: Double) {
            self.key = "data.temperature-ground"
            self.value = value
        }

        init(sense value: Double) {
            self.key = "data.temperature-sense"
            self.value = value
        }

        var body: some View {
            Dual(key: key, value: number.string(from: value) ?? "", unit: "°C")
        }
    }

    struct Wind: View {
        var speed: Double?
        var direction: Double?

        var text: String? {
            switch direction ?? -1 {
            case 0...22:    return "N"
            case 22...67:   return "NE"
            case 67...112:  return "E"
            case 112...157: return "SE"
            case 157...202: return "S"
            case 202...247: return "SW"
            case 247...292: return "W"
            case 292...337: return "NW"
            case 337...360: return "N"
            default: return nil
            }
        }

        var body: some View {
            Triple(key: "data.wind", first: text, second: speed.map { String($0) }, unit: "km/h")
        }
    }

    struct Humidity: View {
        var number: NumberFormatter = .standard
        var value: Double

        var body: some View {
            Dual(key: "data.humidity", value: number.string(from: value) ?? "", unit: "%")
        }
    }

    struct Pressure: View {
        var number: NumberFormatter = .standard
        var value: Double

        var body: some View {
            Dual(key: "data.pressure", value: number.string(from: value) ?? "", unit: "hPa")
        }
    }

    struct Rain: View {
        var number: NumberFormatter = .standard
        var value: Double

        var body: some View {
            Dual(key: "data.rain", value: number.string(from: value) ?? "", unit: "mm")
        }
    }

    struct Updated: View {
        var date: Date

        var body: some View {
            Single(key: "data.updated", value: DateFormatter.standard.string(from: date))
                .listRowBackground(date.obsolete ? Color.obsolete : nil)
        }
    }

    // MARK: -

    struct Single: View {
        var key: String
        var value: String

        var body: some View {
            HStack {
                Key(text: key)
                Spacer()
                Value(text: value)
            }
        }
    }

    struct Dual: View {
        var key: String
        var value: String
        var unit: String

        var body: some View {
            HStack {
                Key(text: key)
                Spacer()
                Value(text: value)
                Unit(text: unit)
            }
        }
    }

    struct Triple: View {
        var key: String
        var first: String?
        var second: String?
        var unit: String

        var body: some View {
            HStack {
                Key(text: key)
                Spacer()

                if first != nil {
                    Value(text: first!)

                    if second != nil {
                        Pipe()
                    }
                }

                if second != nil {
                    Value(text: second!)
                    Unit(text: "km/h")
                }
            }
        }
    }

    // MARK: -

    struct Key: View {
        var text: String

        var body: some View {
            Text(LocalizedStringKey(text))
                .foregroundColor(.primary)
                .font(.body)
        }
    }

    struct Value: View {
        var text: String

        var body: some View {
            Text(text)
                .foregroundColor(.primary)
                .font(.headline)
        }
    }

    struct Unit: View {
        var text: String

        var body: some View {
            Text(text)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }

    struct Pipe: View {
        var body: some View {
            Unit(text: "|")
        }
    }
}

extension DateFormatter {
    static var standard: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
}

extension NumberFormatter {
    static var standard: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }

    func string(from value: Double) -> String? {
        string(from: NSNumber(value: value))
    }
}

extension Date {
    var obsolete: Bool {
        timeIntervalSinceNow < -20 * 60
    }
}
