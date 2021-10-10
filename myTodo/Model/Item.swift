//
//  Item.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var orderOfItem: Int = 0
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")//inverse relationを定義
}
