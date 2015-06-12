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
    @IBOutlet var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Get the JSON and parse it
		
		initializeCharacterArray()
        let gameProvider = GameProvider(delegate: self)
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
        //TODO: something
        self.game = game
        updateUI(game)
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
		
		
		for (var i = 0; i < characters.count; i++) {
            if characters[i] == " " { continue }
			characters2[i] = String(characters[i]).lowercaseString == String(character).lowercaseString ? characters[i] : "X"
		}
		return String(characters2)
	
    }
    
    //MARK: On collectionViewCell tapped
    
	func processGuess(string: String, originalString: String, guess:Character) -> String {
		let characters = Array(originalString)
		var characters2 = Array(string)
		
        if ((originalString.rangeOfString(String(guess))) != nil){
            
            for (var i = 0; i < characters.count; i++) {
                characters2[i] = String(characters[i]).uppercaseString == String(guess).uppercaseString ? characters[i] : characters2[i]
            }
            
        }else{
            
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
        
    }
    
    func incorrectAnswer(){
        if (points >= 0){
        points = points-50
        pointsLabel.text = "Points: \(points)"
        }
    }

}

