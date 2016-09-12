//
//  NSUserDefaults+DefaultStationStore.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Damian Rzeszot. All rights reserved.
//

import Foundation


private let kDefaultWeatherStationKey = "weather-station-number"


extension NSUserDefaults: DefaultWeatherStationStore {

    func setDefaultStation(number: Int) {
        setInteger(number, forKey: kDefaultWeatherStationKey)
        synchronize()
    }

    func getDefaultStation() -> Int? {
        synchronize()
        return valueForKey(kDefaultWeatherStationKey) as? Int
    }

    func clearDefaultStation() {
        setObject(nil, forKey: kDefaultWeatherStationKey)
        synchronize()
    }
    
}


extension DefaultWeatherStationInteractor {

    static func defaults() -> DefaultWeatherStationInteractor {
        return DefaultWeatherStationInteractor(store: NSUserDefaults.standardUserDefaults())
    }

}
