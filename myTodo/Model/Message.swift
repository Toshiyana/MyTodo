//
//  Message.swift
//  myTodo
//
//  Created by Toshiyana on 2021/07/14.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var content: String = ""
    @objc dynamic var name: String = ""
    //@objc dynamic var times: String = ""
    @objc dynamic var dateCreated: Date?
}
