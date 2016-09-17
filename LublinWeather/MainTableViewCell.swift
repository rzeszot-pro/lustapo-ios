//
//  MainTableViewCell.swift
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

import UIKit


class MainTableViewCell: UITableViewCell {

    static var identifier = "cellWeatherParameterReuseIdentifier"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    var parameter: WeatherParameter? {
        didSet {
            if let param = parameter {
                textLabel?.text = stringify(parameter: param)
            } else {
                textLabel?.text = "-"
            }
        }
    }

    var state: WeatherState? {
        didSet {
            if let parameter = parameter, state = state {
                detailTextLabel?.text = stringify(state: state, parameter: parameter)
            } else {
                detailTextLabel?.text = "-"
            }
        }
    }

    func stringify(parameter param: WeatherParameter) -> String {
        switch param {
        case .Temperature: return "Temperatura"
        case .Pressure:    return "Ciśnienie"
        case .WindSpeed:   return "Wiatr"
        case .Rain:        return "Opad"
        case .Date:        return "Data"
        }
    }

    func unitFor(parameter param: WeatherParameter) -> String? {
        switch param {
        case .Temperature: return "°C"
        case .Pressure:    return "hPa"
        case .WindSpeed:   return "km/h"
        case .Rain:        return "mm"
        case .Date:        return nil
        }
    }

    func stringify(state state: WeatherState, parameter param: WeatherParameter) -> String {
        let value: AnyObject?

        switch param {
        case .Temperature:  value = state.temperature
        case .Pressure:     value = state.pressure
        case .Rain:         value = state.rain
        case .WindSpeed:    value = state.windSpeed
        case .Date:         value = state.date
        }

        guard let v = value else {
            return "-"
        }

        let unit = unitFor(parameter: param)

        if let v = v as? Double {
            return format(v) + " \(unit!)"
        }

        if let v = v as? String {
            return v
        }

        return "-"
    }

    lazy var formatter: NSNumberFormatter = {
        let f = NSNumberFormatter()
        f.numberStyle = .DecimalStyle
        f.minimumFractionDigits = 1
        f.maximumFractionDigits = 1
        return f
    }()

    func format(number: Double) -> String {
        return formatter.stringFromNumber(number) ?? "-"
    }

}
