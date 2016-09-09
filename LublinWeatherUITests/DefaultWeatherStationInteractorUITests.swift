//
//  DefaultWeatherStationInteractorUITests.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 09/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import XCTest


extension XCUIApplication {

    func restart() {
        terminate()
        launch()
    }

}


class DefaultWeatherStationInteractorUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        app.launch()
    }


    // MARK: - UI

    var mainNav: XCUIElement {
        return app.navigationBars["Lubelskie Stacje Pogodowe"]
    }

    var table: XCUIElement {
        return app.tables.elementBoundByIndex(0)
    }

    var firstCell: XCUIElement {
        return table.cells.elementBoundByIndex(0)
    }


    func testStoringDefaultWeatherStation() {
        XCTAssertTrue(mainNav.exists, "should be on main scene")

        let old = label(of: firstCell)
        print("old station: \(old)")

        firstCell.tap() // go to selection scene

        let availableCells = reject(label: old, from: table.cells.allElementsBoundByIndex)
        let newSelectedCell = sample(from: availableCells)

        let new = label(of: newSelectedCell)
        print("new station: \(new)")

        newSelectedCell.tap() // select station, back to main scene

        XCTAssertEqual(label(of: firstCell), new)

        app.restart()

        XCTAssertTrue(mainNav.exists, "should be on main scene")
        XCTAssertEqual(label(of: firstCell), new)
    }


    // MARK: - Helpers

    private func sample(from collection: [XCUIElement]) -> XCUIElement {
        let index = Int(arc4random_uniform(UInt32(collection.count)))
        return collection[index]
    }

    private func reject(label text: String, from collection: [XCUIElement]) -> [XCUIElement] {
        return collection.filter { element in
            return self.label(of: element) != text
        }
    }

    private func label(of element: XCUIElement) -> String {
        return element.staticTexts.elementBoundByIndex(0).label
    }

}
