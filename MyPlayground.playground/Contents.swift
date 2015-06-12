//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func replaceAllOccurencesInString(string: String, originalString: String, character: Character) -> String {
	let characters = Array(originalString)
	var characters2 = Array(string)
	let result = ""
	
	
	for (var i = 0; i < characters.count; i++) {
		characters2[i] = characters[i] == character ? character : "X"
	}
	return String(characters2)
}

replaceAllOccurencesInString("XXXXX", "STEVE", "E")


func processGuess(string: String, originalString: String, guess:Character) -> String {
	let characters = Array(originalString)
	var characters2 = Array(string)
	
	for (var i = 0; i < characters.count; i++) {
		characters2[i] = characters[i] == guess ? guess : characters2[i]
	}
	return String(characters2)
}

let ans = processGuess("SXXXX", "STEVE", "T")
let ans2 = processGuess(ans, "STEVE", "E")
processGuess(ans2, "STEVE", "V")


contains("hello", "E")

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

"[a-zA-Z ]" =~ "a"

