//
//  UserDefault.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 04/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

    let defaults: UserDefaults
    let key: String
    let value: T

    init(wrappedValue value: T, key: String, defaults: UserDefaults) {
        self.value = value
        self.defaults = defaults
        self.key = key
    }

    init(wrappedValue: T, key: String) {
        self.init(wrappedValue: wrappedValue, key: key, defaults: .standard)
    }

    var wrappedValue: T {
        get {
            defaults.object(forKey: key) as? T ?? value
        }
        set(value) {
            defaults.set(value, forKey: key)
        }
    }

    func reset() {
        defaults.set(nil, forKey: key)
    }

}
