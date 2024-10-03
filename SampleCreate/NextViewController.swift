//
//  NextViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/12.
//

import UIKit

class NextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CatchRemoveButton,UIPickerViewDelegate,UIPickerViewDataSource {
   
    
    var items : [String] = ["りんご","バナナ","みかん"]
    var items2: [String] = ["東京","埼玉","千葉","神奈川","栃木","茨城"]
    var deletetAllItems:[Int] = []
    let addresList: [String] = ["兵庫","大阪","京都","奈良"]
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var pickerView: UIPickerView = UIPickerView()
    
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
        
        // ピッカー呼び出し
        picker()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int

    {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return self.items.count
        } else if section == 1{
            return self.items2.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        // ゴミ箱アイコンをセット
        cell.img.image = UIImage(systemName: "trash")
        // テキストフィールドのテキストをテーブルにセット
        if indexPath.section == 0 {
            cell.label.text = items[indexPath.row]  // セクション1のデータを設定
        } else if indexPath.section == 1 {
            cell.label.text = items2[indexPath.row]  // セクション2のデータを設定
        }
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
        performSegue(withIdentifier: "WeatherViewController", sender: nil)
        // 編集モードだった場合の処理
        if myTableView.isEditing{
            deletetAllItems.append(indexPath.row)
        }
    }
    // セクション間のヘッダー設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 34)

        let title = UILabel()
        title.text = "Section \(section + 1)"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .white
        title.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        title.sizeToFit()
        headerView.addSubview(title)

        // 自動的なフレーム設定を無効化
        title.translatesAutoresizingMaskIntoConstraints = false
        // ラベルの位置をセンター寄せにする
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        // ラベルの左側に余白を指定
        title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true

        return headerView
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
    // セクション2に追加するボタンを押下した時のハンドラ
    @IBAction func addTextSection2(_ sender: Any) {
        // テキストファイールドが空文字の場合は何もしない
        if textBox.text?.count ?? 0 <= 0 {
            return
        }
        // テキストフィールドの値をitems2に追加
        let item = textBox.text!
        items2.append("\(String(describing: item))")
        // テーブルに列を挿入
        let indexPath = IndexPath(row: items2.count - 1, section: 1)
        myTableView.insertRows(at: [indexPath], with: .automatic)
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
    
    //　MARK: - ここからピッカーの記述
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addresList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return addresList[row]
    }
    
    // キーボード内に表示するピッカーの設定
    func picker(){
        // ピッカー設定
        pickerView.delegate = self
        pickerView.dataSource = self
        // 決定・キャンセル用のツールバーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
                
        // インプットビュー設定
        textBox.inputView = pickerView
        textBox.inputAccessoryView = toolbar
    }
        // 決定ボタンのアクション指定
        @objc func done() {
            textBox.endEditing(true)
            textBox.text = "\(addresList[pickerView.selectedRow(inComponent: 0)])"
        }
        // キャンセルボタンのアクション指定
        @objc func cancel(){
            textBox.endEditing(true)
        }
        // 画面タップでテキストフィールドを閉じる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            textBox.endEditing(true)
        }

    
}

