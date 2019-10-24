//
//  DisclaimerView.swift
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

struct DisclaimerView: View {

    var open: () -> Void

    var body: some View {
        VStack {
            Text("disclaimer.top")

            MoreButton(action: open)
                .padding(.vertical, 20)

            Text("disclaimer.bottom")

            Spacer()
        }
        .padding(20)
        .navigationBarTitle("disclaimer.title")
        .modifier(LifeCycleAnalytics(id: "disclaimer"))
    }

    // MARK: -

    struct MoreButton: View {
        var action: () -> Void

        var body: some View {
            Button(action: action, label: {
                Text("disclaimer.more")
            })
        }
    }

}

extension DisclaimerView {
    init(url: URL) {
        self.init(open: {
            UIApplication.shared.open(url, options: [:]) { success in
                collector.track("disclaimer.open", params: ["success": success])
            }
        })
    }

    init() {
        self.init(url: .website)
    }
}

private extension URL {
    static var website: URL {
        "https://www.umcs.pl/pl/pogoda-w-regionie,2812.htm"
    }
}
