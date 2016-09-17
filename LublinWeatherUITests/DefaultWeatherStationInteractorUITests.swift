//
//  DefaultWeatherStationInteractorUITests.swift
//  LublinWeather
//
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

import XCTest


class DefaultWeatherStationInteractorUITests: XCTestCase {


    // MARK: - Configuration

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


    // MARK: - Tests

    func testStoringLastUsedStation() {
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
