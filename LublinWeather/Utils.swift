//
//  Utils.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 22/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation


typealias JSONDictionary = [String: AnyObject]

extension Dictionary
{
	func get<T>(key: Key) -> T?
	{
		return self[key] as? T
	}
}
