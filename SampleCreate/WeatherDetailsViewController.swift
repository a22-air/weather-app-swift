//
//  WeatherDetailsViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/03.
//

import UIKit

// プロジェクト内のWeatherCode.jsonの構造体
struct WeatherData: Codable {
    let weather_icons: [WeatherIcon]
}
// プロジェクト内のWeatherCode.jsonの構造体
struct WeatherIcon: Codable {
    let key: Int // 天気のキー
    let id: String // 天気のアイコンのid
    let description: String // 天気の説明
}

class WeatherDetailsViewController: UIViewController {
    var receveItemsList:[[String]] = [[],[]] // NextViewControllerから受け取ったテーブルビューのデータ
    var receveIndexPath: IndexPath = [] // NextViewControllerから受け取ったテーブルのindex
    var selectLocation: String = "" // テーブルビューで押下された都道府県
    // 各都道府県の経度と緯度
    let locationCode: [String: (Double, Double)] = [
        "兵庫": (34.69, 135.18),
        "東京": (35.68, 139.69),
        "北海道": (43.065, 141.347),
        "沖縄": (26.21, 127.68),
        "大阪": (34.686, 135.520),
        "奈良": (34.685, 135.833),
        "京都": (35.021, 135.756),
        "神奈川": (35.448, 139.642)
    ]
    
    @IBOutlet weak var todayLabel: UILabel! // 今日の日付を表示
    @IBOutlet weak var maxTemperatureLabel: UILabel! // 今日の最高気温を表示
    @IBOutlet weak var minTemperatureLabel: UILabel! // 今日の最低気温を表示
    @IBOutlet weak var weatherImage: UIImageView! // 今日の天気の画像を表示
    @IBOutlet weak var prefecturesLabel: UILabel! // 選択時の都道府県
    @IBOutlet weak var weatherLabel: UILabel! // 今日の天気をテキストで表示
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // インジゲーター
    // APIの天気コードから天気のアイコンを取得
    func setWeatherIcon(weatherKey: Int) {
        for weatherDatas in weatherDataArray {
            // APIの今日の天気のコードからWeatherCode.jsonのkeyと一致したらアイコンを表示
            if weatherKey == weatherDatas.key {
                // イメージビューにアイコンをセット
                weatherImage.image = UIImage(named: weatherDatas.id)
                // 天気のアイコンの説明を表示
                weatherLabel.text = weatherDatas.description
                return
            } else {
                // 何もしない
            }
        }
    }
    
    // 今日の日付
    var today: String = "" {
        // 変更があればラベルのテキストを変更する
        didSet{
            todayLabel.text = today
        }
    }
    // 今日の最高気温
    var maxTemperature: Double = 0.0 {
        didSet {
            maxTemperatureLabel.text = "最高気温:" + String(maxTemperature)
        }
    }
    // 今日の最低気温
    var minTemperature: Double = 0.0 {
        didSet {
            minTemperatureLabel.text = "最低気温:" + String(minTemperature)
        }
    }
    // 今日の天気のコード
    var weather: Int = 0 {
        didSet {
            // 今日の天気のコードからアイコンを設定する関数の呼び出し
            setWeatherIcon(weatherKey: weather)
        }
    }

    // WeatherCode.jsonのデータを格納
    var weatherDataArray: [WeatherIcon] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.//
        
        // インジゲータの設定
        if let activityIndicator = activityIndicator {
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            self.activityIndicator.startAnimating()
        } else {
            print("activityIndicator is nil")
        }

        // 押下されたテーブルビューのインデックス番号を使い都道府県のkeyを代入
        selectLocation = receveItemsList[receveIndexPath[0]][receveIndexPath[1]] // 例："兵庫"を代入
        
        // テーブルビューで選択した都道府県をラベルに表示する
        prefecturesLabel.text = selectLocation + "の天気"
        
        // 選択時の都道府県からAPIのURLを生成する関数
        func urlCreation(location: String) -> String {
            if let coordinates = locationCode[location] {
                // テーブルビューのインデックスから都道府県を取得しURLをString型で作成
                let urlString = "https://api.open-meteo.com/v1/forecast?latitude=" + "\(coordinates.0)" + "&longitude=" + "\(coordinates.1)" + "&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,uv_index_clear_sky_max&timezone=Asia%2FTokyo"
                return urlString
            } else {
                print("指定された場所が見つかりません")
                return "URL結合失敗"
            }
        }
        
        // MARK: -天気のAPIを取得する
        // 選択された都道府県のクエリパラメータを使用し、URLを作成する
        let url: URL = URL(string: urlCreation(location: selectLocation))!
        

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            // エラー発生時にアラートを表示する
            if let error = error {
                print("Error発生: \(error)")
                // メインスレッドからUIを変更する
                DispatchQueue.main.async {
                    let alertController:UIAlertController =
                    UIAlertController(title:"指定先のURLがありません",
                                      message: "都道府県を選択してください",
                                      preferredStyle: .alert)
                    // Cancel のaction
                    let cancelAction:UIAlertAction =
                    UIAlertAction(title: "Back",
                                  style: .cancel,
                                  handler:{
                        (action:UIAlertAction!) -> Void in
                        // 前の画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    })
                    // actionを追加
                    alertController.addAction(cancelAction)
                    // UIAlertControllerの起動
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            // dataがnilでないことを確認
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                // JSONを辞書型に変換
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                
                // "daily"キーのデータを取り出し、"time"配列の最初の要素を取得
                if let dailyData = json["daily"] as? [String: Any],
                   let timeArray = dailyData["time"] as? [String],
                   let maxTemperatureArray = dailyData["temperature_2m_max"] as? [Double],
                   let minTemperatureArray = dailyData["temperature_2m_min"] as? [Double],
                   let weatherArray = dailyData["weather_code"] as? [Int]{
                    // メインスレッドで実行する
                    DispatchQueue.main.async() { () -> Void in
                        self.today = timeArray[0] // 今日の日付
                        self.maxTemperature = maxTemperatureArray[0] // 今日の最高気温
                        self.minTemperature = minTemperatureArray[0] // 今日の最低気温
                        self.weather = weatherArray[0]
                        print("today:",self.today) // 後で削除
                        print("maxTemperature:",self.maxTemperature) // 後で削除
                        print("minTemperature:",self.minTemperature) // 後で削除
                        print("weather",self.weather) // 後で削除
                        stopIndicator() // インジゲーター非表示
                    }
                }
            } catch {
                // エラー発生時
                print("JSON parsing error: \(error)")
            }
        })
        
        // MARK: -プロジェクト内にある"WeatherCode.json"ファイルのパス取得
        guard let url = Bundle.main.url(forResource: "WeatherCode", withExtension: "json") else {
            fatalError("ファイルが見つからない")
        }
         
        // WeatherCode.jsonの内容をData型プロパティに読み込み
        guard let data = try? Data(contentsOf: url) else {
            fatalError("ファイル読み込みエラー")
        }
        // インジゲーターを非表示にする関数
        func stopIndicator() {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        // JSONデコード処理
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            // WeatherCode.jsonのデータを配列に格納
            weatherDataArray = weatherData.weather_icons
        } catch {
            print("JSONデコードエラー: \(error)")
        }
        // タスクの実行
        task.resume()
        
    }
    // 前の画面に戻る
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // NextViewControllerにreceveItemsListの値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewControllerPage = segue.destination as! NextViewController
        nextViewControllerPage.itemsList = receveItemsList
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
