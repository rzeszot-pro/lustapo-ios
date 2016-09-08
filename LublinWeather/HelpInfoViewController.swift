//
//  HelpInfoViewController.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 06/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import Foundation
import WebKit
import UIKit



class HelpInfoViewController: UIViewController, WKNavigationDelegate
{
	private var webView: WKWebView!
	private var url: NSURL!
	
	convenience init(url: NSURL)
	{
		self.init()
		self.url = url
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		title = "Informacja"
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelClicked))
		
		webView.loadRequest(NSURLRequest(URL: url))
	}
	
	override func loadView()
	{
		super.loadView()
		
		let webView = WKWebView()
		webView.navigationDelegate = self
		putAndOverlay(view: webView, intoView: view)
		self.webView = webView
	}
	
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
	{
		if navigationType == UIWebViewNavigationType.LinkClicked
		{
			UIApplication.sharedApplication().openURL(request.URL!)
			return false
		}
		return true
	}
	
	func cancelClicked()
	{
		dismiss()
	}
	
	private func dismiss()
	{
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - WKNavigationDelegate
	
	// TODO: change it to reactive way
	func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
	{
		if navigationAction.navigationType == .LinkActivated
		{
			if let newURL = navigationAction.request.URL where UIApplication.sharedApplication().canOpenURL(newURL) &&
				UIApplication.sharedApplication().openURL(newURL)
			{
				decisionHandler(.Cancel)
				return
			}
		}
		decisionHandler(.Allow)
	}
}