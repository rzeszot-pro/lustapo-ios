//
//  IntroStatistics.swift
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

struct Intro: View {
    var done: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("intro.title")
                .font(.largeTitle)
                .padding(.vertical, 20)
                .padding(.top, 30)

            DotView(image: Image(systemName: "message.fill"),
                    color: .green,
                    title: Text("intro.feedback.title"),
                    subtitle: Text("intro.feedback.subtitle"),
                    action: feedback)

            DotView(image: Image(systemName: "cube.box.fill"),
                    color: .yellow,
                    title: Text("intro.stats.title"),
                    subtitle: Text("intro.stats.subtitle"),
                    action: statistics)

            Spacer()

            ContinueButton(action: done)
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
        }
        .padding(30)
    }

    // MARK: -

    func feedback() {
        open(url: "https://lustapo.rzeszot.pro/faq/feedback")
    }

    func statistics() {
        open(url: "https://lustapo.rzeszot.pro/faq/stats")
    }

    private func open(url: URL) {
        UIApplication.shared.open(url, options: [:]) { success in
            collector.track("intro.open", params: ["success": success, "url": url])
        }
    }

    // MARK: -

    struct DotView: View {
        var image: Image
        var color: Color
        var title: Text
        var subtitle: Text
        var action: () -> Void

        var body: some View {
            HStack(alignment: .top, spacing: 20) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .foregroundColor(color)

                VStack(alignment: .leading, spacing: 5) {
                    title
                        .multilineTextAlignment(.leading)

                    subtitle
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.secondary)
                        .font(.footnote)

                    HStack {
                        Spacer()
                        MoreButton(action: action)
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }

    // MARK: -

    struct MoreButton: View {
        var action: () -> Void

        var body: some View {
            Button(action: action, label: {
                Image(systemName: "arrow.right.circle")
            })
        }
    }

    struct ContinueButton: View {
        var action: () -> Void

        var body: some View {
            Button(action: action, label: {
                HStack {
                    Spacer()
                    Text("intro.continue")
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.vertical, 17)
            })
            .background(Color.accentColor)
            .cornerRadius(10)
        }
    }

}
