//
//  NextViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/12.
//

import UIKit

class NextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,Section1RemoveCell,UIPickerViewDelegate,UIPickerViewDataSource,Section2RemoveCell {
    
    enum useColorTypes:String, CaseIterable {
        case red = "赤"
        case green = "緑"
        case yellow = "黄"
        case pink = "ピンク"
    }

    var itemsList: [[String]] = [["いちご","オレンジ","もも"],["兵庫","東京","北海道","沖縄"]]
    var deletetAllItems:[[Int]] = [[],[]]
    let addresList: [String] = ["大阪","京都","奈良","神奈川"]
    var sendIndexPath :IndexPath = []
    
    @IBOutlet weak var myTableView: UITableView! // テーブルビュー
    @IBOutlet weak var textBox: UITextField! // テキストフィールド
    @IBOutlet weak var editButton: UIButton! // 編集ボタン
    @IBOutlet weak var datePicker: UIDatePicker! // 日付ピッカー
    @IBOutlet weak var sliderValue: UILabel! // スライダー横のラベル
    @IBOutlet weak var valueVar: UISlider! // スライダー
    @IBOutlet weak var colorSegments: UISegmentedControl! // カラー用セグメント

    var pickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 使用するカスタムセルの登録
        myTableView.register(UINib(nibName:"MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        myTableView.register(UINib(nibName: "SubTableViewCell", bundle: nil), forCellReuseIdentifier: "SubCell")
        myTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        // テキストフィールドのレイアウトの指定
        textBox.layer.borderColor = UIColor.gray.cgColor
        textBox.layer.borderWidth = 1.0
        textBox.layer.cornerRadius = 5.0
        
        // セルの背景を変更する
        myTableView.tableFooterView = UIView()
        
        // ピッカー呼び出し
        picker()
        
        // セグメントの設定
        colorSegments.removeAllSegments()
        useColorTypes.allCases.forEach {
            colorSegments.insertSegment(withTitle: $0.rawValue, at: colorSegments.numberOfSegments, animated: false)
        }
        colorSegments.selectedSegmentIndex = 0

    }
    
    func numberOfSections(in tableView: UITableView) -> Int

    {
        return itemsList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for (index, items) in self.itemsList.enumerated() {
            if section == index {
                return items.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // セクション1のカスタムセルの設定
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
            // テキストフィールドのテキストをテーブルにセット
            if indexPath.section == 0 {
                cell.label.text = itemsList[0][indexPath.row]  // セクション1のデータを設定
            } else if indexPath.section == 1 {
                cell.label.text = itemsList[1][indexPath.row]  // セクション2のデータを設定
            }
            cell.indexNum = indexPath.row // カスタムセルのindex
            cell.imgDelegate = self
            return cell
            
        } else { // セクション2のカスタムセルの設定
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
            cell.label.text = itemsList[1][indexPath.row]
            cell.imgDelegate = self
            cell.indexNum = indexPath.row
            return cell
        }
    }
    // WeatherDetailsViewControllerの画面にitemsListを渡す処理
    // テーブル押下時に画面遷移する処理（セクション1とセクション2で異なる画面に遷移)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先が WeatherDetailsViewController であるかをチェック
        if let weatherDetailsViewControllerPage = segue.destination as? WeatherDetailsViewController {
            // itemsList を渡す
            weatherDetailsViewControllerPage.receveItemsList = itemsList
            // インデックスパスを渡す
            weatherDetailsViewControllerPage.receveIndexPath = sendIndexPath
        } else {
            print("WeatherDetailsViewControllerではありません")
        }
    }

    // テーブルの選択ボタンを押下した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モードだった場合の処理
        if tableView.isEditing {
            let section: Int = indexPath.section // section番号の取得
            deletetAllItems[section].append(indexPath.row)
        } else {
            // 編集モードではない時に異なる画面に遷移する
            if indexPath.section == 0 {
                if let vc = storyboard?.instantiateViewController(withIdentifier: "FruitViewController") as? FruitViewController {
                    // FruitsViewController への遷移
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print("FruitsViewController が見つかりませんでした")
                }
            } else {
                // sendIndexPathを設定してデータを渡す
                sendIndexPath = indexPath
                
                if let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherDetailsViewController {
                    // データを直接渡す
                    vc.receveItemsList = itemsList
                    vc.receveIndexPath = sendIndexPath
                    // WeatherDetailsViewController への遷移
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print("WeatherViewController が見つかりませんでした")
                }
            }
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
    // セクション間のフッター設定
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.lightGray // 背景色を設定
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 34) // フッターの高さを設定

        let title = UILabel()
        title.text = "フッター"
        title.textAlignment = .center
        title.frame = footerView.frame

        footerView.addSubview(title)
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 34 // フッターの高さを指定
    }

    
    
    // セルを削除する関数
    func removeCell(myCell: UITableViewCell){
        guard let indexPath = myTableView.indexPath(for: myCell) else {
            return
        }
        let section =  indexPath.first ?? 0
        itemsList[section].remove(at: indexPath.row)
        myTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // 追加ボタン1のハンドラ
    @IBAction func addText(_ sender: Any) {
        // セクション1にテキストを追加
        addTextToSection(itemArray: &itemsList[0], section: 0)
    }
    // 追加ボタン2のハンドラ
    @IBAction func addTextSection2(_ sender: Any) {
        // セクション2にテキストを追加
        addTextToSection(itemArray: &itemsList[1], section: 1)
    }
    // 追加ボタンの共通の処理を行うメソッド
    func addTextToSection(itemArray: inout [String], section: Int) {
        // テキストフィールドが空文字の場合は何もしない
        guard let text = textBox.text, !text.isEmpty else {
            return
        }
        
        // テキストフィールドの値を配列に追加
        itemArray.append(text)
        
        // テーブルに新しい行を挿入
        let indexPath = IndexPath(row: itemArray.count - 1, section: section)

        // メインスレッドでUIの更新を行う
        DispatchQueue.main.async {
            self.myTableView.insertRows(at: [indexPath], with: .automatic)
            // テキストフィールドをクリア
            self.textBox.text = ""
        }
    }

    // 編集ボタンを押下時のハンドラ
    @IBAction func changeMode(_ sender: Any) {
        if(myTableView.isEditing == true){
            // 削除ボタンの時の処理
            editButton.setTitle("編集", for: .normal)
            myTableView.isEditing = false
            // テーブルビューから削除
            for (section, indices) in deletetAllItems.enumerated() {
                // 削除するアイテムのインデックスを降順にソートしてから削除
                let sortedIndices = indices.sorted(by: >)
                
                var indexPathsToDelete: [IndexPath] = []
                
                for index in sortedIndices {
                    itemsList[section].remove(at: index)
                    indexPathsToDelete.append(IndexPath(row: index, section: section))
                }
                // テーブルビューセルから削除
                myTableView.deleteRows(at: indexPathsToDelete, with: .automatic)
                deletetAllItems = [[],[]]
            }
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
    // デートピッカーの値をテキストフィールドにセット
    @IBAction func getDateButton(_ sender: Any) {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            textBox.text = formatter.string(from: datePicker.date)
        }
    
    // MARK: - スライダーの設定
    // スライダーの設定
    @IBAction func changeValue(_ sender: UISlider) {
        let intSliderValue:Int = Int(sender.value)
        // スライダー横のラベルにスライダーの文字をセット
        sliderValue.text = String(intSliderValue)
    }
    // スライダー横のボタンの設定
    @IBAction func settingSliderValue(_ sender: Any) {
        let intSliderValue:Int = Int(valueVar.value)
        // テキストフィールドにスライダーのvalueをセット
        textBox.text = String(intSliderValue)
    }
    
    // MARK: - セグメントの設定
    // ボタン押下でテーブルビューの背景色を変更
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case useColorTypes.red.rawValue: myTableView.backgroundColor = UIColor.red
        case useColorTypes.yellow.rawValue: myTableView.backgroundColor = UIColor.yellow
        case useColorTypes.green.rawValue: myTableView.backgroundColor = UIColor.green
        case useColorTypes.pink.rawValue: myTableView.backgroundColor = UIColor.systemPink
        default: myTableView.backgroundColor = UIColor.red
        }
    }
    
    // 前の画面に戻る
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

