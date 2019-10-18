//
//  UserDefault.swift
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

class Default<Value>: ObservableObject {

    // MARK: -

    let objectWillChange = ObservableObjectPublisher()
    let key: String
    let value: Value
    let userDefaults: UserDefaults

    // MARK: -

    init(key: String, value: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.value = value
        self.userDefaults = userDefaults
    }

    func get() -> Value {
        userDefaults.object(forKey: key) as? Value ?? value
    }

    func set(_ value: Value) {
        userDefaults.set(value, forKey: key)
        objectWillChange.send()
    }

}

extension UserDefaults {
    // swiftlint:disable identifier_name
    static var show_instance: Default<Bool?> = .init(key: "show-distance", value: nil)

    static var last_station: Default<String?> = .init(key: "last-station", value: nil)
    static var ask_shown: Default<Bool> = .init(key: "ask-shown", value: false)

    static var analytics: Default<Bool> = .init(key: "analytics", value: false)

    static var intro: Default<Int?> = .init(key: "intro", value: nil)

    static var installation_id: Default<String> = .init(key: "installation-id", value: UUID().uuidString.lowercased())
}
