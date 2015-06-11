//
//  Game.swift
//  WikiGameSwift1
//
//  Created by Niket Shah on 10/06/2015.
//  Copyright (c) 2015 Jonny Baho. All rights reserved.
//

import UIKit

struct Game: Printable {
	let title: String
	let extract: String
	
	var description: String {
		return "\(title): \(extract)"
	}
}
