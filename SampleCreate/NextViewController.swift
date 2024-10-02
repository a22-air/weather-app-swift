//
//  NextViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/12.
//

import UIKit

class NextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CatchRemoveButton {
    var items : [String] = ["りんご","バナナ","みかん"]
    var deletetAllItems:[Int] = []
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.register(UINib(nibName:"MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // テキストフィールドのレイアウトの指定
        textBox.layer.borderColor = UIColor.gray.cgColor
        textBox.layer.borderWidth = 1.0
        textBox.layer.cornerRadius = 5.0
        
        // セルの背景を変更する
        myTableView.tableFooterView = UIView()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int

    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        // ゴミ箱アイコンをセット
        cell.img.image = UIImage(systemName: "trash")
        // テキストフィールドのテキストをテーブルにセット
        cell.label.text = self.items[indexPath.row]
        // カスタムセルのindex
        cell.indexNum = indexPath.row
        //
        cell.imgDelegate = self
        // ボタンのタイトル
        cell.colorCangeButton.setTitle("色を変更", for: .normal)
        
        return cell
    }
    
    // テーブルの選択ボタンを押下した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モードだった場合の処理
        if myTableView.isEditing{
            deletetAllItems.append(indexPath.row)
        } else {
            // 通常時は何もしない
        }
    }
    // セルを削除する関数
    func removeCell(myCell: UITableViewCell){
        guard let indexPath = myTableView.indexPath(for: myCell) else {
               return
           }
        items.remove(at: indexPath.row)
        myTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // 追加ボタンを押下した時のハンドラ
    @IBAction func addText(_ sender: Any) {
        // テキストフィールドが空文字の場合は何もしない
        if (textBox.text?.count ?? 0 <= 0) {
            print("TEXT")
            return
        }
        // テキストフィールドの値をitemsに追加
        let item = textBox.text!
        items.append("\(String(describing: item))")
        // テーブルに列を挿入
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        myTableView.insertRows(at: [indexPath], with: .automatic)
        
        textBox.text = ""
    }
    // 編集ボタンを押下時のハンドラ
    @IBAction func changeMode(_ sender: Any) {
        if(myTableView.isEditing == true){
            // 削除ボタンの時の処理
            editButton.setTitle("編集", for: .normal)
            myTableView.isEditing = false
            // 削除するアイテムのインデックスを降順にソートしてから削除
            let sortedIndices = deletetAllItems.sorted(by: >)
            for index in sortedIndices {
                items.remove(at: index)
            }
            // テーブルビューから削除
            myTableView.deleteRows(at: sortedIndices.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            deletetAllItems.removeAll()
        } else {
            // 編集ボタンの時の処理
            editButton.setTitle("削除", for: .normal)
            myTableView.allowsMultipleSelectionDuringEditing = true// 複数選択モードにする処理
            myTableView.isEditing = true
        }
    }


    
}

