//
//  Regex.swift
//  WikiGameSwift1
//
//  Created by Niket Shah on 12/06/2015.
//  Copyright (c) 2015 Jonny Baho. All rights reserved.
//

import Foundation

class Regex {
	let internalExpression: NSRegularExpression
	let pattern: String
	
	init(_ pattern: String) {
		self.pattern = pattern
		var error: NSError?
		self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
	}
	
	func test(input: String) -> Bool {
		let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
		return matches.count > 0
	}
}

infix operator =~ {}

func =~ (input: String, pattern: String) -> Bool {
	return Regex(pattern).test(input)
}