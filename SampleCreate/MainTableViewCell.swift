//
//  MainTableViewCell.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/30.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var str = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // タップ
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeText)))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
       
    }
    @objc
    func removeText() {
        print("OK")
    }
}
