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

class WeatherStationListViewController: UITableViewController
{
	var completionAction: (WeatherStation? -> Void)?
	
	convenience init()
	{
		self.init(style: UITableViewStyle.Plain)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		title = "Stacje pogodowe"
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelClicked))
	}
	
	func dismiss()
	{
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func cancelClicked()
	{
		completionAction?(nil)
		dismiss()
	}
	
	// MARK: - UITableViewDelegate, UITableViewDataSource

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return weatherStationList.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
		cell.textLabel?.text = weatherStationList[indexPath.row].name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		completionAction?(weatherStationList[indexPath.row])
		dismiss()
	}
}