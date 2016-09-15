//
//  LastUsedStationInteractor.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Damian Rzeszot. All rights reserved.
//


protocol LastUsedStationStore {
    func setLastUsedStation(identifier: Int)
    func getLastUsedStation() -> Int?
    func clearLastUsedStation()
}


class LastUsedStationInteractor {

    var store: LastUsedStationStore

    init(store: LastUsedStationStore) {
        self.store = store
    }

    func load() -> Int? {
        return store.getLastUsedStation()
    }

    func save(identifier: Int) {
        store.setLastUsedStation(identifier)
    }

    func clear() {
        store.clearLastUsedStation()
    }

}
