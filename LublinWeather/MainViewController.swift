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

private struct Model
{
	let station: WeatherStation
	let state: WeatherState?
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	private var model: Model = Model(station: weatherStationList.first!, state: nil)
	
	private let cells: [CellDesc] = [.StationName, .WeatherParameterCell(parameter: .Temperature), .WeatherParameterCell(parameter: .Pressure), .WeatherParameterCell(parameter: .WindSpeed), .WeatherParameterCell(parameter: .Rain), .WeatherParameterCell(parameter: .Date)]
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		title = "Lubelskie Stacje Pogodowe"
		tableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: cellWeatherParameterReuseIdentifier)
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellStationNameReuseIdentifier)
		reloadData(model.station)
	}
	
	private func reloadData(station: WeatherStation)
	{
		weatherStateSignalProducer(station).observeOn(UIScheduler()).startWithResult
			{ [weak self] result in
				switch result
				{
				case .Failure(let error):
					print("show error \(error)")
					self?.model = Model(station: station, state: nil)
					self?.tableView.reloadData()
				case .Success(let data):
					self?.model = Model(station: station, state: data)
					self?.tableView.reloadData()
				}
		}
	}
	
	private func reloadDataImmediately(station: WeatherStation)
	{
		model = Model(station: station, state: nil)
		tableView.reloadData()
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
			let value = getValuesForCell(param, data: model.state)
			cell.textLabel?.text = value.0
			cell.detailTextLabel?.text = value.1
			return cell
		case .StationName:
			let cell = tableView.dequeueReusableCellWithIdentifier(cellStationNameReuseIdentifier, forIndexPath: indexPath)
			cell.accessoryType = .DisclosureIndicator
			cell.textLabel?.text = model.station.name
			return cell
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		if case .StationName = cells[indexPath.row]
		{
			let vc = WeatherStationListViewController()
			vc.completionAction = { [weak self] station in
				if let stationValue = station
				{
					self?.reloadDataImmediately(stationValue)
					self?.reloadData(stationValue)
				}
				else
				{
					if let selectedRow = self?.tableView.indexPathForSelectedRow
					{
						self?.tableView.deselectRowAtIndexPath(selectedRow, animated: true)
					}
				}
			}
			let nv = UINavigationController(rootViewController: vc)
			showViewController(nv, sender: self)
		}
	}
}
