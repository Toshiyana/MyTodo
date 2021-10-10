//
//  Category.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var orderOfCategory: Int = 0
    let items = List<Item>()//realmで1対多のrelationalなdatabaseを作る際にList<型>を定義
    
}
