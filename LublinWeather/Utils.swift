//
//  Utils.swift
//  LublinWeather
//
//  Copyright (c) 2016 Piotr Woloszkiewicz
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


import UIKit


extension UIApplication {

    var isUnitTesting: Bool {
        return NSProcessInfo.processInfo().environment["XCTestConfigurationFilePath"] != nil
    }

}



extension NSTimeZone {

    class func GMT() -> NSTimeZone {
        return NSTimeZone(forSecondsFromGMT: 0)
    }

}



extension UIActivityIndicatorView {

    convenience init(activityIndicatorStyle style: UIActivityIndicatorViewStyle, animating flag: Bool) {
        self.init(activityIndicatorStyle: style)
        if flag {
            startAnimating()
        }
    }

}



typealias JSONDictionary = [String: AnyObject]

extension Dictionary {

	func get<T>(key: Key) -> T? {
		return self[key] as? T
	}

}


func putAndOverlay(view view: UIView, intoView: UIView) {
	view.translatesAutoresizingMaskIntoConstraints = false
	intoView.addSubview(view)
	let views = ["view":view]
	intoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: .DirectionRightToLeft, metrics: nil, views: views))
	intoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: .DirectionRightToLeft, metrics: nil, views: views))
}
