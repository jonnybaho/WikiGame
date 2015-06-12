//
//  GameProvider.swift
//  WikiGameSwift1
//
//  Created by Niket Shah on 10/06/2015.
//  Copyright (c) 2015 Jonny Baho. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol GameReader {
	func receivedNewGame(game: Game)
}

class GameProvider: NSObject {
	
	var delegate: GameReader?
	
	func getGameObject() {
		Alamofire.request(.GET, "https://en.wikipedia.org/w/api.php?action=query&list=random&format=json&rnnamespace=0&rnlimit=1")
			.responseJSON { (request, response, data, error) in
				let json1 = JSON(data!)
				let pageid = json1["query"]["random"][0]["id"].stringValue
				Alamofire.request(.GET, "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&pageids=\(pageid)")
					.responseJSON { (request, response, data1, error) in
						let json = JSON(data1!)
						let pages = json["query"]["pages"]
						for (key: String, subJson: JSON) in pages {
							//Do something you want
							let game = Game(title: subJson["title"].stringValue, extract: subJson["extract"].stringValue)
							self.delegate?.receivedNewGame(game)
						}
				}
		}
	}
	
}
