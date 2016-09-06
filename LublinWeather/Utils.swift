//
//  Utils.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 22/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation
import UIKit

typealias JSONDictionary = [String: AnyObject]

extension Dictionary
{
	func get<T>(key: Key) -> T?
	{
		return self[key] as? T
	}
}



func putAndOverlay(view view: UIView, intoView: UIView)
{
	view.translatesAutoresizingMaskIntoConstraints = false
	intoView.addSubview(view)
	let views = ["view":view]
	intoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: .DirectionRightToLeft, metrics: nil, views: views))
	intoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: .DirectionRightToLeft, metrics: nil, views: views))
}