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

private let parameterMissingValue = "-"

private enum CellDesc
{
	case WeatherParameterCell(parameter: WeatherParameter)
	case StationName
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


private func stringRepresentationOfValue(value: NSDecimalNumber?, unit: String, defaultResult: String = parameterMissingValue) -> String
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


// TODO: refactor this
private func getWeatherParameterDataForCell(parameter: WeatherParameter, data: WeatherState?) -> (title: String, value: String)
{
	switch parameter
	{
	case .Temperature:
		return ("Temperatura", stringRepresentationOfValue(data?.temperature, unit: "°C"))
	case .Pressure:
		return ("Ciśnienie", stringRepresentationOfValue(data?.pressure, unit: "hPa"))
	case .WindSpeed:
		var windSpeedFinal: NSDecimalNumber? = nil
		if let windSpeed = data?.windSpeed
		{
			windSpeedFinal = windSpeed.decimalNumberByMultiplyingBy(NSDecimalNumber(double: 3.6))
		}
		return ("Wiatr", stringRepresentationOfValue(windSpeedFinal, unit: "km/h"))
	case .Rain:
		return ("Opad", stringRepresentationOfValue(data?.rain, unit: "mm"))
	case .Date:
		return ("Data", data?.date ?? parameterMissingValue)
	}
}



private let kWeatherStationNumberKey = "weatherStationNumber"

private func getSettingsDefaultWeatherStationNumber() -> Int?
{
	return NSUserDefaults.standardUserDefaults().integerForKey(kWeatherStationNumberKey)
}

private func putSettingsDefaultWeatherStationNumber(stationNumber: Int)
{
	let userDefaults = NSUserDefaults.standardUserDefaults()
	userDefaults.setInteger(stationNumber, forKey: kWeatherStationNumberKey)
	userDefaults.synchronize()
}


private func getSettingsDefaultWeatherStation() -> WeatherStation
{
	if let weatherStationNumber = getSettingsDefaultWeatherStationNumber()
	{
		if let weatherStation = convertWeatherStationNumberToWeatherStation(weatherStationNumber)
		{
			return weatherStation
		}
	}
	return weatherStationList.first! // default weather station
}

private func convertWeatherStationNumberToWeatherStation(stationNumber: Int) -> WeatherStation?
{
	return 0 <= stationNumber && stationNumber < weatherStationList.count ? weatherStationList[stationNumber] : nil
}

private func convertWeatherStationToWeatherStationNumber(station: WeatherStation) -> Int?
{
	return weatherStationList.indexOf(station)
}

private func setSettingsDefaultWeatherStation(station: WeatherStation)
{
	if let stationNumber = convertWeatherStationToWeatherStationNumber(station)
	{
		putSettingsDefaultWeatherStationNumber(stationNumber)
	}
}




private class MainTableViewCell: UITableViewCell
{
	override init(style: UITableViewCellStyle, reuseIdentifier: String?)
	{
		super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
		selectionStyle = .None
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}





private enum LocalModel
{
	case Value(station: WeatherStation, state: WeatherState?)
	case Error(station: WeatherStation, error: NSError)
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	private var localModel = LocalModel.Value(station: getSettingsDefaultWeatherStation(), state: nil)
	
	private let cells: [CellDesc] = [
		.StationName,
		.WeatherParameterCell(parameter: .Temperature),
		.WeatherParameterCell(parameter: .Pressure),
		.WeatherParameterCell(parameter: .WindSpeed),
		.WeatherParameterCell(parameter: .Rain),
		.WeatherParameterCell(parameter: .Date)
	]
	
	private let (weatherStationSignal, weatherStationObserver) = Signal<WeatherStation, NoError>.pipe()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		title = "Lubelskie Stacje Pogodowe"
		tableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: cellWeatherParameterReuseIdentifier)
		tableView.registerNib(UINib(nibName: "StationNameCell", bundle: nil), forCellReuseIdentifier: cellStationNameReuseIdentifier)

		// Alternative UNICODE character: \u{2139}
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "\u{24D8}", style: .Plain, target: self, action: #selector(infoClick))
		
		weatherStationSignal
			.observeOn(UIScheduler())
			.on(event: { [weak self] (event: Event<WeatherStation, NoError>) in
				if let station = event.value
				{
					self?.localModel = LocalModel.Value(station: station, state: nil)
					self?.tableView.reloadData()
				}
			})
			.flatMap(.Latest)
			{ (station) ->  SignalProducer<LocalModel, NoError> in
				return weatherStateSignalProducer(station)
					.map
					{ (state) -> LocalModel in
						return LocalModel.Value(station: station, state: state)
					}
					.flatMapError
					{ (error) -> SignalProducer<LocalModel, NoError> in
						return SignalProducer(value: LocalModel.Error(station: station, error: error))
					}
			}
			.observeOn(UIScheduler())
			.observeNext { [weak self] newLocalModel in
				self?.localModel = newLocalModel
				self?.tableView.reloadData()

				if case .Value(let station, _) = newLocalModel
				{
					setSettingsDefaultWeatherStation(station)
				}
			}
		
		if case .Value(let model) = localModel
		{
			weatherStationObserver.sendNext(model.station)
		}
	}
	
	func infoClick()
	{
		let url = NSBundle.mainBundle().URLForResource("Information", withExtension: "html")!
		let vc = HelpInfoViewController(url: url)
		let nc = UINavigationController(rootViewController: vc)
		showViewController(nc, sender: self)
	}

	private func deselectCurrentRow()
	{
		if let selectedRow = tableView.indexPathForSelectedRow
		{
			tableView.deselectRowAtIndexPath(selectedRow, animated: true)
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
		case .StationName:
			let cell = tableView.dequeueReusableCellWithIdentifier(cellStationNameReuseIdentifier, forIndexPath: indexPath) as! StationNameCell

			let stationName: String!
			switch localModel {
			case .Value(let station, let state):
				stationName = station.name
				if state == nil
				{
					cell.activityIndicator.startAnimating()
				}
				else
				{
					cell.activityIndicator.stopAnimating()
				}
			case .Error(let station, _):
				stationName = station.name
				cell.activityIndicator.stopAnimating()
			}
			cell.nameLabel.text = stationName
			return cell
		case .WeatherParameterCell(let param):
			var state: WeatherState? = nil
			if case .Value(_, let currState) = localModel
			{
				state = currState
			}
			let cell = tableView.dequeueReusableCellWithIdentifier(cellWeatherParameterReuseIdentifier, forIndexPath: indexPath)
			let value = getWeatherParameterDataForCell(param, data: state)
			cell.textLabel?.text = value.title
			cell.detailTextLabel?.text = value.value
			return cell
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		if case .StationName = cells[indexPath.row]
		{
			deselectCurrentRow()
			let vc = WeatherStationListViewController()
			vc.completionAction = { [weak self] station in
				if let stationValue = station
				{
					self?.weatherStationObserver.sendNext(stationValue)
				}
			}
			let nv = UINavigationController(rootViewController: vc)
			showViewController(nv, sender: self)
		}
	}
}
