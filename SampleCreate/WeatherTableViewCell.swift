//
//  WeatherTableViewCell.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/18.
//

import UIKit
protocol Section2RemoveCell {
    func removeCell(myCell:UITableViewCell)
}
class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var indexNum:Int = -1
    var imgDelegate: Section2RemoveCell?
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
    // セルを削除する関数の呼び出し
    @objc
    func removeText() {
        if self.indexNum >= 0 {
            imgDelegate?.removeCell(myCell: self)
        }
    }
}
