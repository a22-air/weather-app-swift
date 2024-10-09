//
//  WeatherDetailsViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/03.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    var receveItemsList:[[String]] = [[],[]]
    var today: String = "" // 今日の日付
    var maxTemperature: Double = 0.0 // 最高気温
    var minTemperature: Double = 0.0 // 最低気温
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 天気のAPIを取得する
        let url: URL = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=temperature_2m_max,temperature_2m_min&timezone=Asia%2FTokyo")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            // エラー発生時
            if let error = error {
                print("Error: \(error)")
                return
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
                   let timeArray = dailyData["time"] as? [String] ,
                   let maxTemperatureArray = dailyData["temperature_2m_max"] as? [Double],
                   let minTemperatureArray = dailyData["temperature_2m_min"] as? [Double] {
                    self.today = timeArray[0]
                    self.maxTemperature = maxTemperatureArray[0]
                    self.minTemperature = minTemperatureArray[0]
                    print("today:",self.today)// "2024-10-09"
                    print("maxTemperature:",self.maxTemperature)
                    print("minTemperature:",self.minTemperature)
                }
            } catch {
                // エラー発生時
                print("JSON parsing error: \(error)")
            }
        })

        // タスクの実行
        task.resume()
    }
    
    @IBAction func backButton(_ sender: Any) {
        // 前の画面に戻る
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
