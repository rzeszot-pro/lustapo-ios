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


private func decodeNSDataAsUTF8(data: NSData?) -> String?
{
	if let dataValue = data
	{
		return String(data: dataValue, encoding: NSUTF8StringEncoding)
	}
	return nil
}

private let TransportErrorDomain = "local.transport"
private  enum TransportErrorDomainCodes: Int
{
	case HTTPStatus
	case DataUTF8Parsing
}



private func crateTransortError(code: TransportErrorDomainCodes, localizedString: String) -> NSError
{
	return NSError(domain: TransportErrorDomain, code: code.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: localizedString])
}


private func requestSignalProducer(request: NSURLRequest) -> SignalProducer<String, NSError>
{
	return NSURLSession.sharedSession().rac_dataWithRequest(request)
		.attempt { (data, response) -> Result<(), NSError> in
			let httpResponse = response as! NSHTTPURLResponse
			
			if httpResponse.statusCode == 200
			{
				return .Success()
			}
			
			return .Failure(crateTransortError(.HTTPStatus, localizedString: "HTTP status code \(httpResponse.statusCode)"))
		}.attemptMap { (data, response) -> Result<String, NSError> in
			guard let dataString = decodeNSDataAsUTF8(data) else
			{
				return .Failure(crateTransortError(.DataUTF8Parsing, localizedString: "Can not convert data to UTF8 string."))
			}
			return .Success(dataString)
	}
}

private func createWeatherStationRequest() -> NSURLRequest
{
	let url = NSURL(string: "http://212.182.4.252/data.php?s=16")!
	return NSURLRequest(URL: url)
}


func weatherStationDataSignalProducer()
{
	requestSignalProducer(createWeatherStationRequest()).startWithResult { result in
		if case .Success(let res) = result
		{
			print(res)
		}
	}
}


