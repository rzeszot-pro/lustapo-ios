//
//  HelpInfoViewController.swift
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

import WebKit
import UIKit


class HelpInfoViewController: UIViewController, WKNavigationDelegate {
	private var webView: WKWebView!
	private var url: NSURL!

	convenience init(url: NSURL) {
		self.init()
		self.url = url
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Informacja"
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelClicked))

		webView.loadRequest(NSURLRequest(URL: url))
	}

	override func loadView() {
		super.loadView()

		let webView = WKWebView()
		webView.navigationDelegate = self
		putAndOverlay(view: webView, intoView: view)
		self.webView = webView
	}

	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		if navigationType == .LinkClicked {
            open(url: request.URL!)
			return false
		}
		return true
	}

	func cancelClicked() {
		dismiss()
	}

	// MARK: - WKNavigationDelegate

	func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

		guard navigationAction.navigationType == .LinkActivated else {
            decisionHandler(.Allow)
            return
        }

        guard let newURL = navigationAction.request.URL else {
            decisionHandler(.Allow)
            return
        }

        if open(url: newURL) {
            decisionHandler(.Cancel)
        } else {
            decisionHandler(.Allow)
        }
	}


    // MARK: - Helpers

    private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func open(url url: NSURL) -> Bool {
        let app = UIApplication.sharedApplication()

        guard app.canOpenURL(url) else {
            return false
        }

        app.openURL(url)
        return true
    }

}
