//
//  ViewController.swift
//  WikiGame
//
//  Created by Jonny Baho on 08/06/15.
//  Copyright (c) 2015 Jonny Baho. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, GameReader, UICollectionViewDataSource, UICollectionViewDelegate {
	
	@IBOutlet weak var extractLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	var titleString = ""
	@IBOutlet weak var labelView: UIView!
	@IBOutlet var collectionView: UICollectionView!
	var game: Game = Game(title: "title", extract: "extract")
	var characterArray: [Character] = []
	var points = 500
	var total = 0
	@IBOutlet var pointsLabel: UILabel!
	let gameProvider: GameProvider = GameProvider()
	
	@IBOutlet weak var totalScore: UILabel!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		//TODO: Get the JSON and parse it
		
		total = getSavedTotalScore()
		updateTotalScore()
		initializeCharacterArray()
		
		gameProvider.delegate = self
		gameProvider.getGameObject()
		
		labelView.layer.cornerRadius = 10
		
		collectionView.dataSource = self
		collectionView.delegate = self
		let nib = UINib(nibName: "letterCollectionViewCell", bundle: nil)
		collectionView.registerNib(nib, forCellWithReuseIdentifier: "letterCell")
		
	}
	
	func initializeCharacterArray() {
		for i in 0...25 {
			characterArray.append(Character(UnicodeScalar(65+i)))
		}
	}
	
	func updateUI(game: Game) {
		
		/*
		(?<=://) means preceded by ://
		[^.]+    means any characters except .
		(?=.)    means followed by .
		*/
		
		titleString = game.title
		let titleStringArr = titleString.componentsSeparatedByString(" ")
		var parsedString = game.extract
		
		var ierror: NSError?
		let regex:NSRegularExpression =  NSRegularExpression(pattern: "[A-Z]", options: NSRegularExpressionOptions.CaseInsensitive, error: &ierror)!
		
		let modifiedString = regex.stringByReplacingMatchesInString(titleString, options:NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0, count(titleString)), withTemplate: "X")
		
		titleLabel.text = modifiedString
		
		for (var anint = 0; anint < titleStringArr.count; anint++){
			
			parsedString = parsedString.stringByReplacingOccurrencesOfString(titleStringArr[anint], withString: "X")
			
		}
		
		extractLabel.text = parsedString
		
		showSomeLetters()
		
		
	}
	
	func receivedNewGame(game: Game) {
		let newGame = Game(title: "hello's world", extract: "hello")
		self.game = newGame
		updateUI(newGame)
//		self.game = game
//		updateUI(game)
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		self.view.endEditing(true)
		return false
		
	}
	
	func replaceAllOccurencesInString(string: String, originalString: String, character: Character) -> String {
		
		let characters = Array(originalString)
		var characters2 = Array(string)
		let result = ""
		let nonAlphaCharacterRegex = "[a-zA-Z]"
		
		for (var i = 0; i < characters.count; i++) {
			if String(character) =~ nonAlphaCharacterRegex { continue }
			characters2[i] = String(characters[i]).lowercaseString == String(character).lowercaseString ? characters[i] : "X"
		}
		return String(characters2)
		
	}
	
	//MARK: On collectionViewCell tapped
	
	func processGuess(string: String, originalString: String, guess:Character) -> String {
		let characters = Array(originalString)
		var characters2 = Array(string)
		
		let upperCaseGuess = Character(String(guess).uppercaseString)
		if contains(originalString.uppercaseString, upperCaseGuess) {
			
			for (var i = 0; i < characters.count; i++) {
				let characterCurr = String(characters[i]).stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
				characters2[i] = String(characterCurr).uppercaseString == String(guess).uppercaseString ? characters[i] : characters2[i]
			}
			
		} else {
			
			incorrectAnswer()
			
		}
		
		return String(characters2)
	}
	
	func showSomeLetters(){
		
		let amount = UInt32(count(titleString))
		let randomInt = Int(arc4random_uniform(amount))
		
		let charArray = Array(titleString)
		
		if (charArray[randomInt] != " "){
			
			var firstChar = charArray[randomInt]
			titleLabel.text = replaceAllOccurencesInString(titleLabel.text!, originalString: titleString, character: firstChar)
			// Replace X with the character
			
			///ewgiuhewgohewgoewijgewoij4wy4wy
		}else {
			
			showSomeLetters()
			// Bad code: refreshes the function if the random int lands on a spacebar
			
		}
		
	}
	
	
	//MARK: UICollectionViewDataSource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 26
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("letterCell", forIndexPath: indexPath) as! letterCollectionViewCell
		let row = indexPath.row
		cell.letter = String(characterArray[row])
		return cell
		
	}
	
	//MARK: UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("letterCell", forIndexPath: indexPath) as! letterCollectionViewCell
		let title = titleLabel.text!
		let originalString = game.title
		let guess = characterArray[indexPath.row]
		titleLabel.text = processGuess(titleLabel.text!, originalString: game.title, guess: characterArray[indexPath.row])
		if gameFinished(titleLabel.text!) {
            total += points
			updateTotalScore()
			saveTotalScore()
			resetPoints()
		}
		
	}
	
	func incorrectAnswer(){
		if (points > 0){
			points = points-50 >= 0 ? points-50 : 0
			pointsLabel.text = "\(points)"
		}
	}
	
	
	//MARK: IBOutlets
	
	@IBAction func newGameButtonPressed(sender: AnyObject) {
		gameProvider.getGameObject()
	}
	
	//MARK: --
	
	func gameFinished(gameString: String) -> Bool {
		return gameString == game.title
	}
	
	func updateTotalScore() {
		totalScore.text = "Total Score: \(total)"
	}
	
	func saveTotalScore() {
		let userDefaults = NSUserDefaults.standardUserDefaults()
		userDefaults.setInteger(total, forKey: "totalScore")
		userDefaults.synchronize()
	}
	
	func getSavedTotalScore() -> Int {
		let userDefaults = NSUserDefaults.standardUserDefaults()
		return userDefaults.integerForKey("totalScore")
	}
	
	func resetPoints() {
		points = 500
		pointsLabel.text = "500"
	}
	
	
}

