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
	let result = ""
	
	for (var i = 0; i < characters.count; i++) {
		characters2[i] = characters[i] == guess ? guess : characters2[i]
	}
	return String(characters2)
}

processGuess("SXXXX", "STEVE", "E")
