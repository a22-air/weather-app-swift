//
//  NextViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/12.
//

import UIKit
import RealmSwift

// Orderable プロトコルを定義(セルの並び替え処理で使用)
protocol Orderable {
    var order: Int { get set }
}

class NextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,Section1RemoveCell,UIPickerViewDelegate,UIPickerViewDataSource,Section2RemoveCell,LongCharactersRemoveCell {
    
    enum useColorTypes:String, CaseIterable {
        case red = "赤"
        case green = "緑"
        case yellow = "黄"
        case pink = "ピンク"
    }

    var itemsList: [[String]] = [[],[]]
    var deletetAllItems:[[Int]] = [[],[]]
    let addresList: [String] = ["大阪","京都","奈良","神奈川"]
    var sendIndexPath :IndexPath = []
    var isMaxValue: Bool = false
    
    @IBOutlet weak var myTableView: UITableView! // テーブルビュー
    @IBOutlet weak var textBox: UITextField! // テキストフィールド
    @IBOutlet weak var editButton: UIButton! // 編集ボタン
    @IBOutlet weak var datePicker: UIDatePicker! // 日付ピッカー
    @IBOutlet weak var sliderValue: UILabel! // スライダー横のラベル
    @IBOutlet weak var valueVar: UISlider! // スライダー
    @IBOutlet weak var colorSegments: UISegmentedControl! // カラー用セグメント

    var pickerView: UIPickerView = UIPickerView()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ひらがな入力ができないバグがあったのでキーボードタイプをデフォルトで指定
        textBox.keyboardType = .default
        
        // フルーツのデータをソート
        let fruitData = realm.objects(Fruit.self).sorted(byKeyPath: "order", ascending: true)
        // 都道府県のデータをソート
        let prefecture = realm.objects(Prefectures.self).sorted(byKeyPath: "order", ascending: true)
        
        for i in 0 ..< itemsList.count {
            let count = (i == 0) ? fruitData.count : prefecture.count
            for j in 0 ..< count {
                if i == 0 {
                    itemsList[i].append(fruitData[j].name)
                } else {
                    itemsList[i].append(prefecture[j].place)
                }
            }
        }
        // 使用するカスタムセルの登録
        myTableView.register(UINib(nibName:"MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        myTableView.register(UINib(nibName: "SubTableViewCell", bundle: nil), forCellReuseIdentifier: "SubCell")
        myTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        myTableView.register(UINib(nibName: "LongCharactersTableViewCell", bundle: nil), forCellReuseIdentifier: "LongCharactersCell")
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
        // セクションごとにRealmを呼び出す
        if section == 0 { // フルーツのデータ
            if itemsList[section].count == 0 {
                return 0 // データが無ければ0を返す
            } else {
                return itemsList[section].count
            }
        } else { // 都道府県のデータ
            if itemsList[section].count == 0 {
                return 0 // データが無ければ0を返す
            } else {
                return itemsList[section].count
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // セクション1のカスタムセルの設定
        if indexPath.section == 0 {
            let items = itemsList[indexPath.section]
            // itemsListが14文字以上か判断
            if items[indexPath.row].count >= 14 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LongCharactersCell", for: indexPath) as! LongCharactersTableViewCell
                cell.textView.text = itemsList[indexPath.section][indexPath.row]
                cell.indexNum = indexPath.row // カスタムセルのindex
                cell.imgDelegate = self
                return cell
            } else { // 13文字以下の場合
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
                cell.textLabel!.text = itemsList[indexPath.section][indexPath.row]
                cell.indexNum = indexPath.row // カスタムセルのindex
                cell.imgDelegate = self
                return cell
            }
        } else { // セクション2のカスタムセルの設定
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
            cell.textLabel!.text = itemsList[indexPath.section][indexPath.row]
            cell.indexNum = indexPath.row
            cell.imgDelegate = self
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
                    // sendIndexPathを設定してデータを渡す
                    sendIndexPath = indexPath
                    // データを直接渡す
                    vc.receveItemsList = itemsList
                    vc.receveIndexPath = sendIndexPath
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
    
    // テーブルの選択ボタンが解除された時の処理
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 削除用配列から削除する
        if let deleteIndex = deletetAllItems[indexPath.section].firstIndex(of: indexPath.row){
            deletetAllItems[indexPath.section].remove(at: deleteIndex)
        } else {
            print("削除失敗")
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
    
    // テーブルセルの移動モードの指定
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
    }

    // テーブルセルの移動処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // ソートしたフルーツのデータ
        let fruitData = realm.objects(Fruit.self).sorted(byKeyPath: "order", ascending: true)
        // ソートした都道府県のデータ
        let prefectureData = realm.objects(Prefectures.self).sorted(byKeyPath: "order", ascending: true)
        
        if sourceIndexPath.section == 0 { // セクション1の処理
            sortedTableCell(fruitData, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        } else { // セクション2の処理
            sortedTableCell(prefectureData, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        }

        // itemsListの更新
        // 移動元のデータ
        let element = itemsList[sourceIndexPath.section][sourceIndexPath.row]
        // 移動元のデータを削除
        itemsList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        // itemsListの移動先に移動元のデータを格納
        itemsList[sourceIndexPath.section].insert(element, at: destinationIndexPath.row)
    }
    
    // 並び変えの処理の関数
    func sortedTableCell<T: Object & Orderable>(_ realmData: Results<T>, sourceIndexPath:IndexPath, destinationIndexPath: IndexPath) {
        // Array型に変換
        var realmDataArrya = Array(realmData)
        
        // 移動元のデータを削除した配列
        let movedData = realmDataArrya.remove(at: sourceIndexPath.row)
        // Listの移動先rowにmovedDataを格納
        realmDataArrya.insert(movedData, at:destinationIndexPath.row)
        
        // List型に変換
        let realmDataList = List<T>()
        realmDataList.append(objectsIn: realmDataArrya)
        
        try! realm.write {
            for(index,var realmItem) in realmDataList.enumerated() {
                realmItem.order = index
            }
        }
    }
    
    // セルを削除する関数
    func removeCell(myCell: UITableViewCell) {
        guard let indexPath = myTableView.indexPath(for: myCell) else {
            return
        }

        let realm = try! Realm()
        let section = indexPath.section
        
        let fruitResults = realm.objects(Fruit.self)
        let prefectureResults = realm.objects(Prefectures.self)

        guard indexPath.section < itemsList.count else {
            print("セクションの範囲外です")
            return
        }

        do {
            try realm.write {
                if section == 0 {
                    if indexPath.row < fruitResults.count {
                        realm.delete(fruitResults[indexPath.row])
                        itemsList[section].remove(at: indexPath.row)
                    } else {
                        print("Fruitデータが範囲外です")
                    }
                } else {
                    if indexPath.row < prefectureResults.count {
                        realm.delete(prefectureResults[indexPath.row])
                        itemsList[section].remove(at: indexPath.row)
                    } else {
                        print("Prefecturesデータが範囲外です")
                    }
                }
            }
            myTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error {
            print("Realmトランザクションでエラーが発生しました: \(error)")
        }
    }

    // 追加ボタン1と追加ボタン2の共通の処理を行うメソッド
    func addItem<T: Object>(_ item: T, text: String, section:Int) {
        // テキストフィールドが空文字の場合は何もしない
        guard let text = textBox.text, !text.isEmpty else {
            return
        }
        if let realm = try? Realm() {
            // フルーツのデータ
            try! realm.write {
                if let fruit = item as? Fruit {
                    fruit.name = text
                    itemsList[section].append(textBox.text!)
                } else if let prefecture = item as? Prefectures { // 都道府県のデータ
                    prefecture.place = text
                    itemsList[section].append(textBox.text!)
                }
                realm.add(item)
            }
        }
        // アニメーションをつけてテーブルビューを追加する
        let indexPath = IndexPath(row: itemsList[section].count - 1, section: section)
        
        myTableView.beginUpdates()
        myTableView.insertRows(at: [indexPath], with: .automatic)
        myTableView.endUpdates()
           
        textBox.text = ""
    }

    // 追加ボタン1のハンドラ
    @IBAction func addText(_ sender: Any) {
        let fruit = Fruit()
        addItem(fruit, text: textBox.text!, section: 0)
    }
    
    // 追加ボタン2のハンドラ
    @IBAction func addTextSection2(_ sender: Any) {
        let prefecture = Prefectures()
        addItem(prefecture, text: textBox.text!, section: 1)
    }

    // 編集ボタンを押下時のハンドラ
    @IBAction func changeMode(_ sender: Any) {
        if(myTableView.isEditing == true){
            // 削除ボタンの時の処理
            editButton.setTitle("編集", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.myTableView.isEditing = false
            }
            // realmのデータ
            let fruitData = realm.objects(Fruit.self)
            let prefecture = realm.objects(Prefectures.self)
    
            // 選択されたインデックスをソート
            for (section, indices) in deletetAllItems.enumerated() {
                let sortedIndices = indices.sorted(by: >)
                // セクションの番号ごとに削除するデータを決定する
                for index in sortedIndices {
                    if section == 0 {
                        try! realm.write {
                            // realmから削除
                            realm.delete(fruitData[index])
                            itemsList[section].remove(at: index)
                        }
                    } else {
                        try! realm.write {
                            // realmから削除
                            realm.delete(prefecture[index])
                            itemsList[section].remove(at: index)
                        }
                    }
                    let indexPath = IndexPath(row: index, section: section)
                    myTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            deletetAllItems = [[],[]]
        } else {
            // 編集ボタンの時の処理
            editButton.setTitle("削除", for: .normal)
            myTableView.allowsMultipleSelectionDuringEditing = true// 複数選択モードにする処理
            UIView.animate(withDuration: 0.3) {
                        self.myTableView.isEditing = true
            }
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

