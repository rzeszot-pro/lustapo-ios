//
//  MainTableViewCell.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 16/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit


private let parameterMissingValue = "-"



class MainTableViewCell: UITableViewCell {

    static var identifier = "cellWeatherParameterReuseIdentifier"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createNumberFormatter() -> NSNumberFormatter {
        let result = NSNumberFormatter()
        result.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return result
    }

    private func formatNumber(number: NSNumber?, fractionsDigits: Int = 1) -> String? {
        if let numberValue = number {
            let formatter = createNumberFormatter()
            formatter.maximumFractionDigits = fractionsDigits
            formatter.minimumFractionDigits = fractionsDigits
            return formatter.stringFromNumber(numberValue)
        }
        return nil
    }

    var parameter: WeatherParameter? {
        didSet {
            if let param = parameter {
                textLabel?.text = stringify(parameter: param)
            } else {
                textLabel?.text = "(nil)"
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

    func unitFor(parameter param: WeatherParameter) -> String {
        switch param {
        case .Temperature: return "°C"
        case .Pressure:    return "hPa"
        case .WindSpeed:   return "km/h"
        case .Rain:        return "mm"
        case .Date:        return ""
        }
    }

    var state: WeatherState? {
        didSet {
            update()
        }
    }

    func update() {
        guard let parameter = parameter, state = state else {
            return
        }

        detailTextLabel?.text = getWeatherParameterDataForCell(parameter, data: state)
    }


    private func stringRepresentationOfValue(value: NSDecimalNumber?, unit: String, defaultResult: String = parameterMissingValue) -> String {
        if let valueString = formatNumber(value) {
            return valueString + " " + unit
        } else {
            return defaultResult
        }
    }


    private func getWeatherParameterDataForCell(parameter: WeatherParameter, data: WeatherState?) -> String {
        switch parameter {
        case .Temperature:
            return stringRepresentationOfValue(data?.temperature, unit: unitFor(parameter: parameter))
        case .Pressure:
            return stringRepresentationOfValue(data?.pressure, unit: unitFor(parameter: parameter))
        case .WindSpeed:
            var windSpeedFinal: NSDecimalNumber? = nil
            if let windSpeed = data?.windSpeed {
                windSpeedFinal = windSpeed.decimalNumberByMultiplyingBy(NSDecimalNumber(double: 3.6))
            }
            return stringRepresentationOfValue(windSpeedFinal, unit: unitFor(parameter: parameter))
        case .Rain:
            return stringRepresentationOfValue(data?.rain, unit: unitFor(parameter: parameter))
        case .Date:
            return data?.date ?? parameterMissingValue
        }
    }

}
