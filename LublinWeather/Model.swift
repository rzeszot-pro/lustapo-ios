//
//  Model.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 22/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation

struct WeatherStation
{
	let name: String
	let ip: String
}

private let mainURL = "http://212.182.4.252/data.php"
private func mainURLWithParamStationID(stationId: String) -> String
{
	return mainURL + "?s=" + stationId
}

let weatherStationList = [
	WeatherStation(name: "Plac Litewski i wieża", ip: mainURLWithParamStationID("16")),
	WeatherStation(name: "Ogród Botaniczny", ip: mainURLWithParamStationID("10")),
	WeatherStation(name: "Florianka", ip: mainURLWithParamStationID("12")),
	WeatherStation(name: "Luków", ip: mainURLWithParamStationID("13")),
	WeatherStation(name: "MPWiK Zemborzycka", ip: mainURLWithParamStationID("17")),
	WeatherStation(name: "MPWiK Hajdów", ip: mainURLWithParamStationID("18")),
	WeatherStation(name: "PGK Lubartow", ip: mainURLWithParamStationID("19")),
	WeatherStation(name: "Guciów", ip: mainURLWithParamStationID("11"))
]

struct WeatherState
{
	let temperature: NSDecimalNumber?
	let date: String?
	let pressure: NSDecimalNumber?
	let windSpeed: NSDecimalNumber?
	let rain: NSDecimalNumber?
}

enum WeatherParameter
{
	case Temperature
	case Pressure
	case WindSpeed
	case Rain
	case Date
}

private func convertNSNumberToNSDecimalNumber(value: NSNumber?) -> NSDecimalNumber?
{
	if let v = value
	{
		return NSDecimalNumber(decimal: v.decimalValue)
	}
	return nil
}


extension WeatherState
{
	init(json: JSONDictionary)
	{
		temperature = convertNSNumberToNSDecimalNumber(json.get("temperatureInt"))
		date = json.get("data")
		pressure = convertNSNumberToNSDecimalNumber(json.get("pressureInt"))
		windSpeed = convertNSNumberToNSDecimalNumber(json.get("windSpeedInt"))
		rain = convertNSNumberToNSDecimalNumber(json.get("rainCumInt"))
	}
}


