//
//  Prefectures.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/28.
//

import Foundation
import RealmSwift

class Prefectures: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted dynamic var place = ""
    @Persisted dynamic var order = -1
}
