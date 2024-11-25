//
//  AppDelegate.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/12.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Realmのマイグレーション設定
        let config = Realm.Configuration(
            schemaVersion: 3, // 新しいスキーマバージョン
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    migration.enumerateObjects(ofType: Fruit.className()) { oldObject, newObject in
                        // `id`を初期化（旧オブジェクトには存在しない場合）
                        newObject?["id"] = UUID().uuidString
                    }
                }
            }
        )
        
        // Realmのデフォルト設定を更新
        Realm.Configuration.defaultConfiguration = config
        
        // Realmインスタンスの初期化
        _ = try! Realm()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

