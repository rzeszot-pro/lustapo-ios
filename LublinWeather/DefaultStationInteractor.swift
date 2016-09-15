//
//  DefaultStationInteractor.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 15/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit



protocol DefaultStationProvider {
    func getDefaultStation() -> WeatherStation?
    func setDefaultStation(station: WeatherStation)
}



class DefaultStationInteractor: DefaultStationProvider {

    var listStationsProvider: ListStationsProvider
    var lastUsedStationProvider: LastUsedStationProvider

    var weatherStationList: [WeatherStation] {
        return listStationsProvider.getStations()
    }

    init(listStationsProvider: ListStationsProvider, lastUsedStationProvider: LastUsedStationProvider) {
        self.listStationsProvider = listStationsProvider
        self.lastUsedStationProvider = lastUsedStationProvider
    }

    func getDefaultStation() -> WeatherStation? {
        guard let index = lastUsedStationProvider.load() else {
            return nil
        }

        guard 0 <= index && index < weatherStationList.count else {
            return nil
        }

        return weatherStationList[index]
    }

    func setDefaultStation(station: WeatherStation) {
        guard let stationNumber = weatherStationList.indexOf(station) else {
            return
        }

        lastUsedStationProvider.save(stationNumber)
    }

}
