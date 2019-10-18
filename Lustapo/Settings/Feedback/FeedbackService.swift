//
//  FeedbackService.swift
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

import SwiftUI

class FeedbackService {
    struct Payload: Encodable {
        struct Form: Encodable {
            let email: String
            let details: String
        }
        struct Meta: Encodable {
            let device: String
            let system: String
            let app: String
        }
        let form: Form
        let meta: Meta
    }

    func send(email: String, details: String, completion: @escaping (Bool) -> Void) {
        let payload = Payload(form: .init(email: email, details: details), meta: .current)

        var request = URLRequest(url: "https://lustapo.rzeszot.pro/api/feedback")
        request.timeoutInterval = 10
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(payload)
        request.allHTTPHeaderFields = ["version": "1"]

        URLSession.shared.dataTask(with: request) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200

            DispatchQueue.main.async {
                completion(success)
            }
        }.resume()
    }
}

private extension FeedbackService.Payload.Meta {
    static var current: FeedbackService.Payload.Meta {
        let device = UIDevice.current
        let bundle = Bundle.main

        let system = device.systemName + " " + device.systemVersion
        let app = (bundle.name ?? "") + " " + (bundle.version ?? "")

        return .init(device: device.modelCode ?? "unknown", system: system, app: app)
    }

}

extension UIDevice {

    var modelCode: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String.init(validatingUTF8: ptr)
            }
        }

        return modelCode
    }

    // swiftlint:disable cyclomatic_complexity
    static func name(from code: String) -> String? {
        switch code {
        case "iPhone10,5":
            return "iPhone 8+"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPhone11,6":
            return "iPhone XS max"
        case "iPhone11,4":
            return "iPhone XS max"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone10,2":
            return "iPhone 8+"
        case "iPhone10,1":
            return "iPhone 8"
        default:
            return nil
        }
    }

}
