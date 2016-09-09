//
//  DefaultWeatherStationInteractor.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Damian Rzeszot. All rights reserved.
//


protocol DefaultStationStore {
    func setDefaultStation(identifier: Int)
    func getDefaultStation() -> Int?
}


class DefaultWeatherStationInteractor {

    private var store: DefaultStationStore

    init(store: DefaultStationStore) {
        self.store = store
    }

    func load() -> Int? {
        return store.getDefaultStation()
    }

    func store(identifier: Int) {
        store.setDefaultStation(identifier)
    }

}
