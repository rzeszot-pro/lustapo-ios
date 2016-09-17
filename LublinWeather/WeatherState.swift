//
//  Model.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 22/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//


// swiftlint:disable variable_name


import Foundation



struct WeatherState {
	let temperature: Double?
	let date: String?
	let pressure: Double?
	let windSpeed: Double?
	let rain: Double?
}
