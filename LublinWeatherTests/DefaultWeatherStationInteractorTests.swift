//
//  DefaultWeatherStationInteractorTests.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import XCTest
@testable import LuStaPo


class MockDefaultWeatherStationStore: DefaultWeatherStationStore {

    private var value: Int?

    func setDefaultStation(identifier: Int) {
        value = identifier
    }

    func getDefaultStation() -> Int? {
        return value
    }

    func clearDefaultStation() {
        value = nil
    }

}


class DefaultWeatherStationInteractorTests: XCTestCase {

    let station = DefaultWeatherStationInteractor(store: MockDefaultWeatherStationStore())

    func testNoIdentifierOnStartup() {
        station.clear()
        XCTAssertNil(station.load())
    }

    func testIdentifierWhenStored() {
        station.save(5)
        XCTAssertEqual(station.load(), 5)
    }

    func testDifferentIdentifierThanStored() {
        station.save(1)

        XCTAssertNotNil(station.load())
        XCTAssertNotEqual(station.load(), 2)
    }

    func testClearingStoredIdentifier() {
        station.save(5)
        station.clear()

        XCTAssertNil(station.load())
    }

}
