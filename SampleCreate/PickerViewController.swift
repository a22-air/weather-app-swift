//
//  PickerViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/11/21.
//

import UIKit
import PhotosUI

class PickerViewController: UIViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // ボタン押下時にピッカーを表示する処理
    @IBAction func openPictures(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        // 取得するタイプの指定(写真)
        configuration.filter = .images
        // 選択可能枚数の指定(0は無制限)
        configuration.selectionLimit = 1
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
                self?.img.image = image
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
