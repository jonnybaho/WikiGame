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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let unparsedString = "{'query':{'pages':{'3747':{'pageid':3747,'ns':0,'title':'Bill Gates','extract':'William Henry 'Bill' Gates III (born October 28, 1955) is an American business magnate, philanthropist, investor, computer programmer, and inventor. Gates originally established his reputation as the co-founder of Microsoft, the world largest PC software company, with Paul Allen. During his career at Microsoft, Gates held the positions of chairman, CEO and chief software architect, and was also the largest individual shareholder until May 2014. He has also authored and co-authored several books.\nToday he is consist'"
        
        /*
        (?<=://) means preceded by ://
        [^.]+    means any characters except .
        (?=.)    means followed by .
        */
        
        let titleRange = unparsedString.rangeOfString("(?<='title':')[^']+(?=)", options:.RegularExpressionSearch)
        let range = unparsedString.rangeOfString("(?<=extract':')[^\n]+(?=)", options:.RegularExpressionSearch)

        if (range != nil && titleRange != nil){
            
            let titleString = unparsedString.substringWithRange(titleRange!)
                // "Bill Gates"
            // Bill + Gates 
            let titleStringArr = titleString.componentsSeparatedByString(" ")
            
            var parsedString = unparsedString.substringWithRange(range!)

            for (var anint = 0; anint < titleStringArr.count; anint++){
                
                parsedString = parsedString.stringByReplacingOccurrencesOfString(titleStringArr[anint], withString: "X")
                
            }
            
            extractLabel.text = parsedString

        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func guessButton(sender: AnyObject) {
        
        
        
    }

}

