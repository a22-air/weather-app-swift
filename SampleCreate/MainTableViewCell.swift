//
//  MainTableViewCell.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/30.
//

import UIKit

protocol CatchRemoveButton {
    func removeData(id:Int)
}

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var colorCangeButton: UIButton!
    
    var indexNum:Int = -1
    var imgDelegate: CatchRemoveButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // タップ
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeText)))
        
        // ボタンのアクションを設定
        colorCangeButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
    }

    // セルの背景を変更する処理
    @objc
    func changeColor(_ sender: Any) {
        if self.contentView.backgroundColor == UIColor.blue{
            self.contentView.backgroundColor = UIColor.clear
        } else {
            self.contentView.backgroundColor = UIColor.blue
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
       
    }
    @objc
    func removeText() {
        if self.indexNum >= 0 {
            imgDelegate?.removeData(id: indexNum)
        }
    }
}
