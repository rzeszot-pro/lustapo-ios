//
//  DefaultStationInteractor.swift
//  LublinWeather
//
//  Copyright (c) 2016 Piotr Woloszkiewicz
//  Copyright (c) 2016 Damian Rzeszot
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
