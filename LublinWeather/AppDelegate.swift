//
//  AppDelegate.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 18/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
	{
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.rootViewController = MainViewController(nibName: "MainViewController", bundle: nil)
		window?.makeKeyAndVisible()
		return true
	}
	

	func applicationWillResignActive(application: UIApplication)
	{
	}
	

	func applicationDidEnterBackground(application: UIApplication)
	{
	}
	

	func applicationWillEnterForeground(application: UIApplication)
	{
	}
	

	func applicationDidBecomeActive(application: UIApplication)
	{
	}
	

	func applicationWillTerminate(application: UIApplication)
	{
	}
}

