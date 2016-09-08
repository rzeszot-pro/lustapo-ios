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

private let mainURL = "http://212.182.4.252/"
private func mainURLWithStationParam(stationParam: String) -> String
{
	return mainURL + stationParam
}

let weatherStationList = [
	WeatherStation(name: "Lublin - Plac Litewski", ip: mainURLWithStationParam("data.php?s=16")),
	WeatherStation(name: "Lublin - Ogród Botaniczny", ip: mainURLWithStationParam("data.php?s=10")),
	WeatherStation(name: "Lublin - MPWiK Zemborzycka", ip: mainURLWithStationParam("data.php?s=17")),
	WeatherStation(name: "Lublin - MPWiK Hajdów", ip: mainURLWithStationParam("data2.php?s=18")),
	WeatherStation(name: "Lubartów", ip: mainURLWithStationParam("data.php?s=19")),
	WeatherStation(name: "Guciów", ip: mainURLWithStationParam("data.php?s=11")),
	WeatherStation(name: "Florianka", ip: mainURLWithStationParam("data2.php?s=12")),
	WeatherStation(name: "Łuków", ip: mainURLWithStationParam("data2.php?s=13"))
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
		
		let windSpeed = convertNSNumberToNSDecimalNumber(json.get("windSpeedInt"))
		if windSpeed != nil
		{
			self.windSpeed = windSpeed
		}
		else
		{
			self.windSpeed = convertNSNumberToNSDecimalNumber(json.get("windSpeed"))
		}

		let rain = convertNSNumberToNSDecimalNumber(json.get("rainCumInt"))
		if rain != nil
		{
			self.rain = rain
		}
		else
		{
			self.rain = convertNSNumberToNSDecimalNumber(json.get("rainT"))
		}
	}
}


