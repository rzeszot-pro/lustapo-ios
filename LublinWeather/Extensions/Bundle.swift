//
//  Bundle.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation

extension Bundle {

    open var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    open var build: String? {
        return infoDictionary?[kCFBundleVersionKey as String] as? String
    }

    open var numeric: Int? {
        return infoDictionary?["CFBundleNumericVersion"] as? Int
    }

    open var display: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }

    open var name: String? {
        return infoDictionary?[kCFBundleNameKey as String] as? String
    }

}
