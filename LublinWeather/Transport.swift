//
//  Transport.swift
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

// swiftlint:disable force_try
// swiftlint:disable variable_name
// swiftlint:disable force_cast

import Foundation
import ReactiveCocoa
import Result


private let regex = try! NSRegularExpression(pattern: "([a-zA-Z][a-zA-Z0-9]+):", options: .AnchorsMatchLines)

private func fixBrokenJSON(data: NSData) -> NSData? {
	guard let dataString = decodeNSDataAsUTF8(data) else {
		return nil
	}
	let fullRange = NSRange(location: 0, length: dataString.characters.count)
	let result = NSMutableString(string: dataString)
	regex.replaceMatchesInString(result, options: NSMatchingOptions.WithoutAnchoringBounds, range: fullRange, withTemplate: "\"$1\":")
	return result.dataUsingEncoding(NSUTF8StringEncoding)
}


private func decodeNSDataAsUTF8(data: NSData?) -> String? {
	if let dataValue = data {
		return String(data: dataValue, encoding: NSUTF8StringEncoding)
	}
	return nil
}

func parseJSONData(data: NSData) -> [String: AnyObject]? {
	do {
		let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves)
		return json as? [String: AnyObject]
	} catch let exc {
		print("ERROR: Parse data JSON: \(exc)")
	}
	return nil
}

private let TransportErrorDomain = "Local.Transport"
private  enum TransportErrorDomainCodes: Int {
	case HTTPStatus
	case DataParsing
}



private func crateTransportError(code: TransportErrorDomainCodes, localizedString: String) -> NSError {
	return NSError(domain: TransportErrorDomain, code: code.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: localizedString])
}


private func requestForJSONSignalProducer(request: NSURLRequest) -> SignalProducer<JSONDictionary, NSError> {
	return NSURLSession.sharedSession().rac_dataWithRequest(request)
		.attempt { (data, response) -> Result<(), NSError> in
			let httpResponse = response as! NSHTTPURLResponse

			if httpResponse.statusCode == 200 {
				return .Success()
			}

			return .Failure(crateTransportError(.HTTPStatus, localizedString: "HTTP status code \(httpResponse.statusCode)"))
		}.attemptMap { (data, response) -> Result<JSONDictionary, NSError> in
			guard let dataFixedJSON = fixBrokenJSON(data) else {
				return .Failure(crateTransportError(.DataParsing, localizedString: "Data parsing (fixing JSON)"))
			}

			guard let json = parseJSONData(dataFixedJSON) else {
				return .Failure(crateTransportError(.DataParsing, localizedString: "Data parsing (JSON)"))
			}
			return .Success(json)
	}
}

private func createWeatherStationRequest(station: WeatherStation) -> NSURLRequest {
	let url = NSURL(string: station.endpoint)!
	return NSURLRequest(URL: url)
}


func weatherStateSignalProducer(station: WeatherStation) -> SignalProducer<WeatherState, NSError> {
    let parser = WeatherStationExtractor()

	return requestForJSONSignalProducer(createWeatherStationRequest(station))
		.map { json -> WeatherState in
			return parser.extract(json)
		}
}
