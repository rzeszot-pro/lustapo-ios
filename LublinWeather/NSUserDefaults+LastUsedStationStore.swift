//
//  NSUserDefaults+DefaultStationStore.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Damian Rzeszot. All rights reserved.
//

import Foundation


private let kDefaultWeatherStationKey = "weather-station-number"


extension NSUserDefaults: LastUsedStationStore {

    func setLastUsedStation(identifier: Int) {
        setInteger(identifier, forKey: kDefaultWeatherStationKey)
        synchronize()
    }

    func getLastUsedStation() -> Int? {
        synchronize()
        return valueForKey(kDefaultWeatherStationKey) as? Int
    }

    func clearLastUsedStation() {
        setObject(nil, forKey: kDefaultWeatherStationKey)
        synchronize()
    }
    
}


extension LastUsedStationInteractor {

    static func defaults() -> Self {
        return .init(store: NSUserDefaults.standardUserDefaults())
    }

}
