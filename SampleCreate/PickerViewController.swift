//
//  PickerViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/11/21.
//

import UIKit
import PhotosUI

class PickerViewController: UIViewController, PHPickerViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgs: UICollectionView!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 使用するカスタムセルの登録
        imgs.register(UINib(nibName: "imgsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        // collection view のレイアウト設定
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 110, height: 110)
//            layout.minimumInteritemSpacing = 20
            imgs.collectionViewLayout = layout
    }
    
    // ボタン押下時にピッカーを表示する処理
    @IBAction func openPictures(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        // 取得するタイプの指定(写真)
        configuration.filter = .images
        // 選択可能枚数の指定(0は無制限)
        configuration.selectionLimit = 0
        // PHPickerViewControllerを初期化して設定を反映させる
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        // 画面遷移処理
        present(picker, animated: true, completion: nil)
    }
    
    // ピッカーの画像が押下された時の処理
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // ピッカーのモーダルを閉じる
        picker.dismiss(animated: true, completion: nil)
        
        // 画像があるかないかの判断をする
        guard let result = results.first else { return }
        // 結果から最初のItemProviderを取得
        let itemProvider = result.itemProvider
        
        // 正常系のクロージャー
        let successHandler: (UIImage) -> Void = { [weak self] image in
            DispatchQueue.main.async {
//                self?.img.image = image
                self?.images.append(image)
                self?.imgs.reloadData()
            }
        }
        
        // 異常系のクロージャー
        let errowHandler: (Error?) -> Void = { error in
            DispatchQueue.main.async {
                print("画像の読み込みでエラーが発生しました:",String(describing: error))
            }
        }
        
        // オプショナルバインディングで取得したItemProviderのnilチェックとロード可能かチェック
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            // ItemProviderから画像を呼び出す
            itemProvider.loadObject(ofClass: UIImage.self) { (image,error) in
                if let image = image as? UIImage {
                    successHandler(image)
                } else {
                    errowHandler(error)
                }
            }
        }
    }
    // セクションの中のセルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! imgsCollectionViewCell
        cell.imgView.image = images[indexPath.row]
            return cell
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
