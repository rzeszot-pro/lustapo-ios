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
        let secret: String
    }

    func send(email: String, details: String, completion: @escaping () -> Void) {
        let payload = Payload(form: .init(email: email, details: details), meta: .init(device: "device", system: "system", app: "app"), secret: "123123123")

        var request = URLRequest(url: "https://lustapo.rzeszot.pro/feedback")
        request.timeoutInterval = 10
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            // TODO: report error
            DispatchQueue.main.async(execute: completion)
        }.resume()
    }
}
