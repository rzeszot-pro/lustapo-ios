//
//  MainViewController.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 19/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

// swiftlint:disable force_cast
// swiftlint:disable opening_brace

import UIKit
import ReactiveCocoa
import Result



private enum CellDesc
{
	case WeatherParameterCell(parameter: WeatherParameter)
	case StationName
}



private enum LocalModel {
	case Value(station: WeatherStation, state: WeatherState?)
	case Error(station: WeatherStation, error: NSError)
}



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listStationsProvider: ListStationsProvider?
    var defaultStationProvider: DefaultStationProvider?

    var weatherStationList: [WeatherStation] {
        return listStationsProvider?.getStations() ?? []
    }

    // TODO: refactor start

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        localModel = .Value(station: WeatherStation(name: "?", ip: "?"), state: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        localModel = .Value(station: WeatherStation(name: "?", ip: "?"), state: nil)
        super.init(coder: aDecoder)
    }

    func setup() {
        localModel = .Value(station: defaultStation, state: nil)
    }

    // TODO: refactor end



	@IBOutlet weak var tableView: UITableView!
    private var localModel: LocalModel

	private let cells: [CellDesc] = [
		.StationName,
		.WeatherParameterCell(parameter: .Temperature),
		.WeatherParameterCell(parameter: .Pressure),
		.WeatherParameterCell(parameter: .WindSpeed),
		.WeatherParameterCell(parameter: .Rain),
		.WeatherParameterCell(parameter: .Date)
	]

	private let (weatherStationSignal, weatherStationObserver) = Signal<WeatherStation, NoError>.pipe()


    // MARK: - View Life Cycle

    override func loadView() {
        super.loadView()

        title = "Lubelskie Stacje Pogodowe"
        tableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.registerNib(UINib(nibName: "StationNameCell", bundle: nil), forCellReuseIdentifier: StationNameCell.identifier)

        // Alternative UNICODE character: \u{2139}
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "\u{24D8}", style: .Plain, target: self, action: #selector(infoClick))
    }

	override func viewDidLoad() {
		super.viewDidLoad()

		weatherStationSignal
			.observeOn(UIScheduler())
			.on(event: { [weak self] (event: Event<WeatherStation, NoError>) in
				if let station = event.value {
					self?.localModel = LocalModel.Value(station: station, state: nil)
					self?.tableView.reloadData()
				}
			})
			.flatMap(.Latest) { (station) ->  SignalProducer<LocalModel, NoError> in
				return weatherStateSignalProducer(station)
					.map { (state) -> LocalModel in
						return LocalModel.Value(station: station, state: state)
					}
					.flatMapError { (error) -> SignalProducer<LocalModel, NoError> in
						return SignalProducer(value: LocalModel.Error(station: station, error: error))
					}
			}
			.observeOn(UIScheduler())
			.observeNext { [weak self] newLocalModel in
				self?.localModel = newLocalModel
				self?.tableView.reloadData()

				if case .Value(let station, _) = newLocalModel {
                    self?.defaultStation = station
				}
			}

		if case .Value(let model) = localModel {
			weatherStationObserver.sendNext(model.station)
		}
	}


    // MARK: - Actions

    @IBAction func infoClick() {
        showHelpViewController()
    }


	// MARK: - Table View

    func configure(stationNameCell cell: StationNameCell) {
        let stationName: String!

        switch localModel {
        case .Value(let station, let state):
            stationName = station.name
            cell.loading = state == nil
        case .Error(let station, _):
            stationName = station.name
            cell.loading = false
        }

        cell.name = stationName
    }

    func configure(weatherParameterCell cell: MainTableViewCell, forParameter param: WeatherParameter) {
        var state: WeatherState? = nil

        if case .Value(_, let currState) = localModel {
            state = currState
        }

        cell.parameter = param
        cell.state = state
    }

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch cells[indexPath.row] {
		case .StationName:
			let cell = tableView.dequeueReusableCellWithIdentifier(StationNameCell.identifier, forIndexPath: indexPath) as! StationNameCell
            configure(stationNameCell: cell)
			return cell
		case .WeatherParameterCell(let param):
            let cell = tableView.dequeueReusableCellWithIdentifier(MainTableViewCell.identifier, forIndexPath: indexPath) as! MainTableViewCell
            configure(weatherParameterCell: cell, forParameter: param)
			return cell
		}
	}

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

		guard case .StationName = cells[indexPath.row] else {
            return
        }

        showStationSelectionViewController()
	}


    // MARK: - Helpers

    var defaultStation: WeatherStation {
        get {
            return defaultStationProvider?.getDefaultStation() ?? weatherStationList.first!
        }
        set {
            defaultStationProvider?.setDefaultStation(newValue)
        }
    }

    func showHelpViewController() {
        let url = NSBundle.mainBundle().URLForResource("Information", withExtension: "html")!
        let vc = HelpInfoViewController(url: url)
        let nc = UINavigationController(rootViewController: vc)

        showViewController(nc, sender: self)
    }

    func showStationSelectionViewController() {
        let vc = WeatherStationListViewController()

        vc.listStationsProvider = listStationsProvider
        vc.completionAction = { [weak self] station in
            if let stationValue = station {
                self?.weatherStationObserver.sendNext(stationValue)
            }
        }

        let nv = UINavigationController(rootViewController: vc)
        showViewController(nv, sender: self)
    }

}
