//
//  Map.swift
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

import SwiftUI
import MapKit

struct Map: View {

    var cancel: () -> Void

    @State
    var landmarks: [MapView.Landmark]

    var body: some View {
        NavigationView {
            MapView(landmarks: $landmarks)
                .edgesIgnoringSafeArea(.all)
                .navigationBarItems(leading: CloseButton(action: cancel))
        }
    }

}

extension Map {
    init(cancel: @escaping () -> Void, stations: [Station]) {
        let landmarks = stations.map { MapView.Landmark(name: $0.name, location: $0.coordinates) }
        self.init(cancel: cancel, landmarks: landmarks)
    }
}

struct MapView: UIViewRepresentable {

    class LandmarkAnnotation: NSObject, MKAnnotation {
        let title: String?
        let coordinate: CLLocationCoordinate2D

        init(landmark: Landmark) {
            self.title = landmark.name
            self.coordinate = landmark.location
        }
    }

    struct Landmark {
        let name: String
        let location: CLLocationCoordinate2D
    }

    @Binding
    var landmarks: [Landmark]

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.removeAnnotations(view.annotations)

        let annotations = landmarks.map { LandmarkAnnotation(landmark: $0) }
        view.addAnnotations(annotations)

        view.showAnnotations(annotations, animated: true)
    }
}
