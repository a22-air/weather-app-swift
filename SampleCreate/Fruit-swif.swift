//
//  Fruit-swif.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/10/21.
//

import Foundation
import RealmSwift

class Fruit: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var order: Int = -1
}
