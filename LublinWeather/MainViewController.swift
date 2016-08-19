//
//  MainViewController.swift
//  LublinWeather
//
//  Created by Piotr Woloszkiewicz on 19/08/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class MainViewController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		print("test")
		
		let (signal, observer) = Signal<String, NoError>.pipe()
		signal.observeResult { (result) in
			print(result)
		}
		observer.sendNext("test")
	}
	
	
}
