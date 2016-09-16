//
//  WeatherStationListViewController.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 22/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation
import UIKit


private let cellId = "cellid"


class WeatherStationListViewController: UITableViewController {

    var listStationsProvider: ListStationsProvider?

    private var list: [WeatherStation] {
        return listStationsProvider?.getStations() ?? []
    }


	var completionAction: (WeatherStation? -> Void)?

	convenience init() {
		self.init(style: .Plain)
	}


    // MARK: - View Life Cycle

    override func loadView() {
        super.loadView()

        title = "Stacje pogodowe"

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelClicked))
    }


    // MARK: - Actions

    @IBAction func cancelClicked() {
        completionAction?(nil)
        dismiss()
    }


	// MARK: - Table View

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let station = list[indexPath.row]

		cell.textLabel?.text = station.name

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let station = list[indexPath.row]

		completionAction?(station)
		dismiss()
	}


    // MARK: -  Helpers

    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
