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

let weatherStationList = [
	WeatherStation(name: "Plac Litewski i wieża", ip: "http://212.182.4.252/data.php?s=16"),
	WeatherStation(name: "Ogród Botaniczny", ip: "http://212.182.4.252/data.php?s=10")
]

struct WeatherState
{
	let temperature: NSDecimalNumber?
	let date: String?
	let pressure: NSDecimalNumber?
	let windSpeed: NSDecimalNumber?
	let rain: NSDecimalNumber?
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


