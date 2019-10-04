//
//  Model.swift
//  Lubelskie Stacje Pogodowe
//
//  Copyright (c) 2016-2019 Damian Rzeszot
//  Copyright (c) 2016 Piotr Woloszkiewicz
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

import Foundation
import Combine
import SwiftUI


class Model: ObservableObject {

    @UserDefault(key: "last-station")
    var last: String? = nil

    @Published
    var regions: [Region]

    @Published
    var station: Station {
        didSet {
            last = station.id
            reload()
        }
    }

    @Published
    private(set) var isReloading: Bool = false

    @Published
    private(set) var data: Payload?

    // MARK: -

    init(regions: [Region], station: Station) {
        self.regions = regions
        self.station = station
    }

    let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "user-agent": "Lustapo (\(Bundle.main.version ?? "nil")+\(Bundle.main.build ?? "nil")) \(UIDevice.current.systemName) (\(UIDevice.current.systemVersion))"
        ]
        config.timeoutIntervalForRequest = 10
        return URLSession(configuration: config)
    }()


    private var cancellable: AnyCancellable?

    func reload() {
        guard !isReloading else { return }

        isReloading = true

        cancellable?.cancel()
        cancellable = session
            .dataTaskPublisher(for: URL(station: station))
            .map { value in
                try? JSONDecoder().decode(Payload.self, from: fix(value.data) ?? Data())
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isReloading = false
            }, receiveValue: { value in
                self.data = value
            })
    }

}


private func fix(_ data: Data) -> Data? {
    guard let string = String(data: data, encoding: .utf8) else { return nil }
    guard let regexp = try? NSRegularExpression(pattern: "([a-zA-Z][a-zA-Z0-9]+):", options: .anchorsMatchLines) else { return nil }

    let result = NSMutableString(string: string)
    regexp.replaceMatches(in: result, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: string.count), withTemplate: "\"$1\":")

    return result.data(using: String.Encoding.utf8.rawValue)
}

extension URL {
    init(station: Station) {
        let parts = station.id.split(separator: "-")
        let version = parts[0] == "0" ? "" : parts[0]

        self = URL(string: "http://212.182.4.252/data\(version).php?s=\(parts[1])")!
    }
}
