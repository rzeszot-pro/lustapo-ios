//
//  Transport.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 19/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result


func decodeNSDataAsUTF8(data: NSData?) -> String?
{
	if let dataValue = data
	{
		return String(data: dataValue, encoding: NSUTF8StringEncoding)
	}
	return nil
}

func stationDataSignalProducer()
{
	let url = NSURL(string: "http://212.182.4.252/data.php?s=16")!
	let request = NSURLRequest(URL: url)
	NSURLSession.sharedSession().rac_dataWithRequest(request)
	.startWithResult { result in
		if case .Success(let res) = result
		{
			print(decodeNSDataAsUTF8(res.0))
		}
	}
}


