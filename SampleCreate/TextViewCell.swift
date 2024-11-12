//
//  TextViewCell.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/11/11.
//

import UIKit

class TextViewCell: UITableViewCell {
    var indexNum:Int = -1
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        textView.backgroundColor = UIColor.gray
    }
    
}
