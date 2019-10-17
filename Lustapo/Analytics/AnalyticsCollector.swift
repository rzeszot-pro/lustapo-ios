//
//  AnalyticsCollector.swift
//  Lubelskie Stacje Pogodowe
//
//  Copyright (c) 2019 Damian Rzeszot
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

class AnalyticsCollector: Collector {
    static let shared: Collector = AnalyticsCollector()

    // MARK: -

    var limit: Int = 10
    var url: URL = "https://analytics.rzeszot.pro/api/collector"

    // MARK: -

    private struct Entry: Encodable {
        let date: Date
        let type: String
        let params: [String: Any]

        enum Key: String, CodingKey {
            case type = "t"
            case date = "d"
            case parameters = "p"
        }

        struct Custom: CodingKey {
            var intValue: Int?
            var stringValue: String

            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            init?(intValue: Int) {
                self.intValue = intValue
                self.stringValue = "Index \(intValue)"
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            var subcontainer = container.superEncoder(forKey: .parameters).container(keyedBy: Custom.self)

            try container.encode(type, forKey: .type)
            try container.encode(date, forKey: .date)

            for (key, value) in params {
                if let value = value as? String {
                    try subcontainer.encode(value, forKey: Custom(stringValue: key)!)
                } else if let value = value as? Bool {
                    try subcontainer.encode(value, forKey: Custom(stringValue: key)!)
                } else {
                    try subcontainer.encode("inencodable", forKey: Custom(stringValue: key)!)
                }
            }
        }
    }

    private var queue: [Entry] = []

    private func handle() {
        if queue.count >= limit {
            publish()
        }
    }

    func publish() {
        guard !queue.isEmpty else { return }

        let entries = queue
        let body = try? JSONEncoder().encode(entries)
        queue = []

        #if DEBUG
            var request = URLRequest(url: "https://localhost:3000/api/collector")
        #else
            var request = URLRequest(url: url)
        #endif

        request.httpMethod = "POST"
        request.httpBody = body
        request.timeoutInterval = 15
        request.allHTTPHeaderFields = ["installation-id": UserDefaults.installation_id.get() ]

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
            // do nothing
        }

        task.resume()
    }

    // MARK: -

    func track(_ type: String, params: [String: Any]) {
        DispatchQueue.main.async {
            self.queue.append(Entry(date: Date(), type: type, params: params))
            self.handle()
        }
    }

}
