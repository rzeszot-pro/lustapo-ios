//
//  StationNameCell.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 06/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit


class StationNameCell: UITableViewCell {

    var loading: Bool {
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
        get {
            return activityIndicator.isAnimating()
        }
    }

    var name: String {
        set {
            nameLabel.text = newValue
        }
        get {
            return nameLabel.text ?? ""
        }
    }

    static var identifier = "cellStationNameReuseIdentifier"



    // TODO: this should be not exposed

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

}
