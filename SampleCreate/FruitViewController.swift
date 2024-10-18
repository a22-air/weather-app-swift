//
//  FriutsViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/17.
//

import UIKit

class FruitViewController: UIViewController {

    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var fruitLabel: UILabel!
    
    var receveItemsList:[[String]] = [[],[]] // NextViewControllerから受け取ったテーブルビューのデータ
    var receveIndexPath: IndexPath = [] // NextViewControllerから受け取ったテーブルのindex
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // テーブルビューで選択されたフルーツをラベルにセット
        fruitLabel.text = receveItemsList[receveIndexPath[0]][receveIndexPath[1]]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
