//
//  AppDelegate.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 18/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
		let navVC = UINavigationController(rootViewController: mainVC)

        mainVC.listStationsProvider = ListStationsInteractor()
        mainVC.defaultStationProvider = DefaultStationInteractor(listStationsProvider: mainVC.listStationsProvider!, lastUsedStationProvider: LastUsedStationInteractor.defaults())

        mainVC.setup()

        window?.rootViewController = navVC
		window?.makeKeyAndVisible()

        return true
	}

}
