//
//  letterCollectionViewCell.swift
//  
//
//  Created by Jonny Baho on 11/06/15.
//
//

import UIKit

class letterCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    //@property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0);
    
    var letter = "" {
        didSet {
            
            titleLabel?.text = letter
        
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
