//
//  MainViewController.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 19/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result


private let cellWeatherParameterReuseIdentifier = "cellWeatherParameterReuseIdentifier"
private let cellStationNameReuseIdentifier = "cellStationNameReuseIdentifier"

private class MainTableViewCell: UITableViewCell
{
	override init(style: UITableViewCellStyle, reuseIdentifier: String?)
	{
		super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}


private enum WeatherParameter
{
	case Temperature
	case Pressure
	case WindSpeed
	case Rain
	case Date
}

private func createNumberFormatter() -> NSNumberFormatter
{
	let result = NSNumberFormatter()
	result.numberStyle = NSNumberFormatterStyle.DecimalStyle
	return result
}

private func formatNumber(number: NSNumber?, fractionsDigits: Int = 1) -> String?
{
	if let numberValue = number
	{
		let formatter = createNumberFormatter()
		formatter.maximumFractionDigits = fractionsDigits
		formatter.minimumFractionDigits = fractionsDigits
		return formatter.stringFromNumber(numberValue)
	}
	return nil
}

private let parameterMissingValue = "-"

private func getValuesForCell(parameter: WeatherParameter, data: WeatherState?) -> (title: String, value: String)
{
	func stringRepresentation(value: NSDecimalNumber?, unit: String, defaultResult: String = parameterMissingValue) -> String
	{
		if let valueString = formatNumber(value)
		{
			return valueString + " " + unit
		}
		else
		{
			return defaultResult
		}
	}
	
	switch parameter
	{
	case .Temperature:
		return ("Temperatura", stringRepresentation(data?.temperature, unit: "°C"))
	case .Pressure:
		return ("Ciśnienie", stringRepresentation(data?.pressure, unit: "hPa"))
	case .WindSpeed:
		return ("Wiatr", stringRepresentation(data?.windSpeed, unit: "km/h"))
	case .Rain:
		return ("Opad", stringRepresentation(data?.rain, unit: "mm"))
	case .Date:
		return ("Data", data?.date ?? parameterMissingValue)
	}
}

private enum CellDesc
{
	case WeatherParameterCell(parameter: WeatherParameter)
	case StationName
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	private let weatherStation = weatherStationList.first!
	private var data: WeatherState?
	private let cells: [CellDesc] = [.StationName, .WeatherParameterCell(parameter: .Temperature), .WeatherParameterCell(parameter: .Pressure), .WeatherParameterCell(parameter: .WindSpeed), .WeatherParameterCell(parameter: .Rain), .WeatherParameterCell(parameter: .Date)]
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		title = "Lubelskie Stacje Pogodowe"
		tableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: cellWeatherParameterReuseIdentifier)
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellStationNameReuseIdentifier)
		
		weatherStateSignalProducer(weatherStation).observeOn(UIScheduler()).startWithResult
			{ [weak self] result in
				switch result
				{
				case .Failure(let error):
					self?.data = nil
					print("show error \(error)")
					self?.tableView.reloadData()
				case .Success(let data):
					self?.data = data
					self?.tableView.reloadData()
				}
			}
	}
	
	// MARK: - UITableViewDelegate, UITableViewDataSource
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return cells.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		switch cells[indexPath.row] {
		case .WeatherParameterCell(let param):
			let cell = tableView.dequeueReusableCellWithIdentifier(cellWeatherParameterReuseIdentifier, forIndexPath: indexPath)
			let value = getValuesForCell(param, data: data)
			cell.textLabel?.text = value.0
			cell.detailTextLabel?.text = value.1
			return cell
		case .StationName:
			let cell = tableView.dequeueReusableCellWithIdentifier(cellStationNameReuseIdentifier, forIndexPath: indexPath)
			cell.textLabel?.text = weatherStation.name
			return cell
		}
	}
}
