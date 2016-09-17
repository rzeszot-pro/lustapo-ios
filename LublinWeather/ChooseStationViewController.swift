//
//  ChooseStationViewController.swift
//  LublinWeather
//
//  Copyright (c) 2016 Piotr Woloszkiewicz
//  Copyright (c) 2016 Damian Rzeszot
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit


class ChooseStationViewController: UITableViewController {


    // MARK: - Initialization

    var listStationsProvider: ListStationsProvider?
    var activeStation: WeatherStation?
    var completionAction: (WeatherStation? -> Void)?

	convenience init() {
		self.init(style: .Plain)
	}


    // MARK: -

    private var list: [WeatherStation] {
        return listStationsProvider?.getStations() ?? []
    }


    // MARK: - View Life Cycle

    override func loadView() {
        super.loadView()

        title = "Stacje pogodowe"

        tableView.registerClass(ChooseStationCell.self, forCellReuseIdentifier: ChooseStationCell.identifer)
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
        guard let cell = tableView.dequeueReusableCellWithIdentifier(ChooseStationCell.identifer, forIndexPath: indexPath) as? ChooseStationCell else {
            fatalError("cell at index path \(indexPath) should be a ChooseStationCell")
        }

        let station = list[indexPath.row]

        cell.name = station.name
        cell.choosen = station == activeStation

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
