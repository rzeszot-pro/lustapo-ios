//
//  DefaultWeatherStationInteractor.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Damian Rzeszot. All rights reserved.
//


protocol DefaultWeatherStationStore {
    func setDefaultStation(identifier: Int)
    func getDefaultStation() -> Int?
    func clearDefaultStation()
}


class DefaultWeatherStationInteractor {

    var store: DefaultWeatherStationStore

    init(store: DefaultWeatherStationStore) {
        self.store = store
    }

    func load() -> Int? {
        return store.getDefaultStation()
    }

    func save(identifier: Int) {
        store.setDefaultStation(identifier)
    }

    func clear() {
        store.clearDefaultStation()
    }

}
