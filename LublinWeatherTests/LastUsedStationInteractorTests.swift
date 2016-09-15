//
//  DefaultWeatherStationInteractorTests.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import XCTest
@testable import LuStaPo


class LastUsedStationInteractorTests: XCTestCase {

    let station = LastUsedStationInteractor.mock()

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
