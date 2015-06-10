//
//  ViewController.swift
//  WikiGame
//
//  Created by Jonny Baho on 08/06/15.
//  Copyright (c) 2015 Jonny Baho. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var extractLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    var titleString = ""
    @IBOutlet weak var labelView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Get the JSON and parse it
        
        let unparsedString = "{'query':{'pages':{'3747':{'pageid':3747,'ns':0,'title':'Bill Gates','extract':'William Henry 'Bill' Gates III (born October 28, 1955) is an American business magnate, philanthropist, investor, computer programmer, and inventor. Gates originally established his reputation as the co-founder of Microsoft, the world largest PC software company, with Paul Allen. During his career at Microsoft, Gates held the positions of chairman, CEO and chief software architect, and was also the largest individual shareholder until May 2014. He has also authored and co-authored several books.\nToday he is consist'"
        
        /*
        (?<=://) means preceded by ://
        [^.]+    means any characters except .
        (?=.)    means followed by .
        */
        
        let titleRange = unparsedString.rangeOfString("(?<='title':')[^']+(?=)", options:.RegularExpressionSearch)
        let range = unparsedString.rangeOfString("(?<=extract':')[^\n]+(?=)", options:.RegularExpressionSearch)
        
        if (range != nil && titleRange != nil){
            
            titleString = unparsedString.substringWithRange(titleRange!).uppercaseString
            let titleStringArr = titleString.componentsSeparatedByString(" ")
            var parsedString = unparsedString.substringWithRange(range!)
            
            for (var anint = 0; anint < titleStringArr.count; anint++){
                
                parsedString = parsedString.stringByReplacingOccurrencesOfString(titleStringArr[anint], withString: "X")
                
            }
            
            extractLabel.text = parsedString

            
            var ierror: NSError?
            let regex:NSRegularExpression =  NSRegularExpression(pattern: "[A-Z]", options: NSRegularExpressionOptions.CaseInsensitive, error: &ierror)!
            
            let modifiedString = regex.stringByReplacingMatchesInString(titleString, options:NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0, count(titleString)), withTemplate: "X")
                
            titleLabel.text = modifiedString
            
        }
        
        showSomeLetters()
        
        labelView.layer.cornerRadius = 10
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessButton(sender: AnyObject) {
        
        if (guessTextField.text.lowercaseString == titleString.lowercaseString ){
            
            titleLabel.text = titleString + " - You were right!"
            
        }else {
            
            titleLabel.text = titleLabel.text! + " - You were wrong!"
            
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                
                    // Bouncing animation? To indicate the wrong answer
                
                }, completion: nil)
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
        
    }
    
    @IBAction func tappedView(sender: AnyObject) {
        
        textFieldShouldReturn(guessTextField)
        
    }
    
    func showSomeLetters(){
        
        let amount = UInt32(count(titleString))
        let randomInt = Int(arc4random_uniform(amount))
        
        let indexesToReplace = Set
        
        let charArray = Array(titleString)
        
        if (charArray[randomInt] != " "){
            
            var firstChar = charArray[randomInt]
            Array(arrayLiteral: titleLabel.text)[randomInt] = firstChar
            
            // Replace X with the character
            
            ///ewgiuhewgohewgoewijgewoij4wy4wy
        }else {
            
            showSomeLetters()
            // Bad code: refreshes the function if the random int lands on a spacebar
            
        }
        
    }
}

