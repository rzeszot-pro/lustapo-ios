//
//  MockLastUsedStationStore.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 15/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

@testable import LuStaPo



class MockLastUsedStationStore: LastUsedStationStore {

    private var value: Int?

    func setLastUsedStation(identifier: Int) {
        value = identifier
    }

    func getLastUsedStation() -> Int? {
        return value
    }

    func clearLastUsedStation() {
        value = nil
    }

}

extension LastUsedStationInteractor {

    class func mock() -> Self {
        return .init(store: MockLastUsedStationStore())
    }

}
