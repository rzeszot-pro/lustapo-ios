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


private let regex = try! NSRegularExpression(pattern: "([a-zA-Z]+):", options: .AnchorsMatchLines)

private func fixBrokenJSON(data: NSData) -> NSData?
{
	guard let dataString = decodeNSDataAsUTF8(data) else
	{
		return nil
	}
	let fullRange = NSRange(location: 0, length: dataString.characters.count)
	let result = NSMutableString(string: dataString)
	regex.replaceMatchesInString(result, options: NSMatchingOptions.WithoutAnchoringBounds, range: fullRange, withTemplate: "\"$1\":")
	return result.dataUsingEncoding(NSUTF8StringEncoding)
}


private func decodeNSDataAsUTF8(data: NSData?) -> String?
{
	if let dataValue = data
	{
		return String(data: dataValue, encoding: NSUTF8StringEncoding)
	}
	return nil
}

func parseJSONData(data: NSData) -> [String: AnyObject]?
{
	do
	{
		let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves)
		return json as? [String: AnyObject]
	}
	catch let exc
	{
		print("ERROR: Parse data JSON: \(exc)")
	}
	return nil
}

private let TransportErrorDomain = "Local.Transport"
private  enum TransportErrorDomainCodes: Int
{
	case HTTPStatus
	case DataParsing
}



private func crateTransportError(code: TransportErrorDomainCodes, localizedString: String) -> NSError
{
	return NSError(domain: TransportErrorDomain, code: code.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: localizedString])
}


private func requestForJSONSignalProducer(request: NSURLRequest) -> SignalProducer<JSONDictionary, NSError>
{
	return NSURLSession.sharedSession().rac_dataWithRequest(request)
		.attempt { (data, response) -> Result<(), NSError> in
			let httpResponse = response as! NSHTTPURLResponse
			
			if httpResponse.statusCode == 200
			{
				return .Success()
			}
			
			return .Failure(crateTransportError(.HTTPStatus, localizedString: "HTTP status code \(httpResponse.statusCode)"))
		}.attemptMap { (data, response) -> Result<JSONDictionary, NSError> in
			guard let dataFixedJSON = fixBrokenJSON(data) else
			{
				return .Failure(crateTransportError(.DataParsing, localizedString: "Data parsing (fixing JSON)"))
			}
			
			guard let json = parseJSONData(dataFixedJSON) else
			{
				return .Failure(crateTransportError(.DataParsing, localizedString: "Data parsing (JSON)"))
			}
			return .Success(json)
	}
}

private func createWeatherStationRequest() -> NSURLRequest
{
	let url = NSURL(string: "http://212.182.4.252/data.php?s=16")!
	return NSURLRequest(URL: url)
}


func weatherStateSignalProducer() -> SignalProducer<WeatherState, NSError>
{
	return requestForJSONSignalProducer(createWeatherStationRequest())
		.map
		{ json -> WeatherState in
			return WeatherState(json: json)
		}
}


