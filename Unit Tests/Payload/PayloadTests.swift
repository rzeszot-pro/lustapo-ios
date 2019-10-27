//
//  PayloadTests.swift
//  Unit Tests
//
//  Created by Damian Rzeszot on 27/10/2019.
//  Copyright © 2019 Lubelskie Stacje Pogodowe. All rights reserved.
//
// swiftlint:disable force_try

import XCTest
@testable import LuStaPo

final class PayloadTests: XCTestCase {

    var decoder: JSONDecoder!

    override func setUp() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.remote)
    }

    override func tearDown() {
        decoder = nil
    }

    // MARK: -

    func testExample() {
        let payload = try! decoder.decode(Payload.self, from: .botan)

        XCTAssertNil(payload.wind.direction)
        XCTAssertNil(payload.wind.speed)

        XCTAssertEqual(payload.temperature.air, 11.7)
        XCTAssertEqual(payload.temperature.sense, 11.7)

        XCTAssertEqual(payload.humidity, 79.9)
        XCTAssertEqual(payload.pressure, 992.6)
        XCTAssertEqual(payload.rain, 0.1)
    }

}

private extension Data {
    static var botan: Data {
        let url = Bundle(for: PayloadTests.self).url(forAuxiliaryExecutable: "botan.json")!
        return fix(try! Data(contentsOf: url))!
    }
}
