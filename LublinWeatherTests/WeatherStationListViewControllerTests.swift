//
//  WeatherStationListViewControllerTests.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 16/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import XCTest
@testable import LuStaPo


class WeatherStationListViewControllerTests: XCTestCase {

    let sut = WeatherStationListViewController()

    var leftBarItem: UIBarButtonItem? {
        return sut.navigationItem.leftBarButtonItem
    }


    // MARK: - Configuration

    override func setUp() {
        super.setUp()
        sut.loadView()
    }


    // MARK: - Tests

    func testLeftBarItemExists() {
        XCTAssertNotNil(leftBarItem)
    }

    func testCancelConnected() {
        guard let target = leftBarItem?.target as? WeatherStationListViewController else {
            XCTFail("cancel button target should be WeatherStationListViewController")
            return
        }

        guard let action = leftBarItem?.action else {
            XCTFail("cancel button action should be Selector")
            return
        }

        XCTAssertEqual(target, sut)
        XCTAssertEqual(action, #selector(WeatherStationListViewController.cancelClicked))
    }

}
