//
//  KeyboardAdaptive.swift
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

import Combine
import SwiftUI

struct KeyboardAdaptive: ViewModifier {

    @State
    private(set) var height: CGFloat = 0

    @State
    private var cancellable: AnyCancellable?

    // MARK: -

    private let show: Publishers.Map<NotificationCenter.Publisher, CGFloat>
    private let hide: Publishers.Map<NotificationCenter.Publisher, CGFloat>

    init(nc: NotificationCenter = .default) {
        show = nc.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0?.height ?? 0 }

        hide = nc.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in 0 }
    }

    private func subscribe() {
        cancellable = show.merge(with: hide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.height, on: self)
    }

    private func unsubscribe() {
        cancellable = nil
    }

    // MARK: - ViewModifier

    func body(content: Content) -> some View {
        content
            .padding(.bottom, height)
            .edgesIgnoringSafeArea(height == 0 ? [] : .bottom)
            .onAppear(perform: subscribe)
            .onDisappear(perform: unsubscribe)
    }

}
