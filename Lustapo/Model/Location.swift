//
//  Location.swift
//  Lubelskie Stacje Pogodowe
//
//  Copyright (c) 2016-2019 Damian Rzeszot
//  Copyright (c) 2016 Piotr Woloszkiewicz
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

import Foundation
import CoreLocation
import Combine

class Location: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: -

    static var shared = Location()

    // MARK: -

    private let manager: CLLocationManager

    init(manager: CLLocationManager = .init()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }

    // MARK: -

    var status: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }

    var authorized: Bool {
        status == .authorizedAlways || status == .authorizedWhenInUse
    }

    var location: CLLocation? {
        manager.location
    }

    func request() {
        manager.requestWhenInUseAuthorization()
    }

    // MARK: - ObservableObject

    let objectWillChange: ObservableObjectPublisher = .init()

    // MARK: - CustomStringConvertible

    override var description: String {
        super.description + " | " + status.description
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        objectWillChange.send()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        objectWillChange.send()
    }

}
