//
//  Model.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


class Model: ObservableObject {

    var regions: [Region]

    @Published
    var active: String? = "Lublin - Ogród Botaniczny UMCS"

    @Published
    private(set) var isReloading: Bool = false

    @Published
    private(set) var data: Payload?

    var station: Station? {
        stations.first { $0.name == active }
    }

    // MARK: -

    init(regions: [Region], active: String?) {
        self.regions = regions
    }

    let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "user-agent": "Lustapo (\(Bundle.main.version ?? "nil")+\(Bundle.main.build ?? "nil")) \(UIDevice.current.systemName) (\(UIDevice.current.systemVersion))"
        ]
        return URLSession(configuration: config)
    }()


    var cancellable: AnyCancellable?

    func reload() {
        print("reload")

        guard let station = station else { return }
        guard !isReloading else { return }

        isReloading = true

        cancellable?.cancel()
        cancellable = session
            .dataTaskPublisher(for: station.endpoint)
            .map { value in try! JSONDecoder().decode(Payload.self, from: fix(value.data) ?? Data()) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isReloading = false
            }, receiveValue: { value in
                self.data = value
            })
    }

    // MARK: -

    var stations: [Station] {
        regions.flatMap { $0.stations }
    }

    // MARK: -

    static var standard: Model {
        Database().load()
    }

}


private func fix(_ data: Data) -> Data? {
    guard let string = String(data: data, encoding: .utf8) else { return nil }
    guard let regexp = try? NSRegularExpression(pattern: "([a-zA-Z][a-zA-Z0-9]+):", options: .anchorsMatchLines) else { return nil }

    let result = NSMutableString(string: string)
    regexp.replaceMatches(in: result, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: string.count), withTemplate: "\"$1\":")

    return result.data(using: String.Encoding.utf8.rawValue)
}
