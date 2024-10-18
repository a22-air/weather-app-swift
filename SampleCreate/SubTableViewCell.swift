//
//  SubTableViewCell.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/17.
//

import UIKit
protocol SubTableViewCellDelegate: AnyObject {
    func didTapButtonInCell(_ cell: SubTableViewCell)
}
class SubTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var img: UIImageView!
    
    var indexNum:Int = -1
    var imgDelegate: SubTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        img.isUserInteractionEnabled = true
//        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeText)))
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @IBAction func callFunc(_ sender: Any) {
        // ボタンがタップされたときにデリゲートメソッドを呼び出す
        print("クリック")
        imgDelegate?.didTapButtonInCell(self)
    }
}
