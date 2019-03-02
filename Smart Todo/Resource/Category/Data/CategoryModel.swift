//
//  CategoryModel.swift
//  Smart Todo
//
//  Created by Marie on 2019/02/19.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
import RealmSwift

// Todoアイテム
class CategoryItem: Object {
//    @objc dynamic var id = 0
    @objc dynamic var categoryTitle = ""
    @objc dynamic var canDeleteFlg = false
    @objc dynamic var createdAt = Date()
    @objc dynamic var priority = false
    
    let todo = List<TodoItem>()
}

class TodoItem: Object {
    @objc dynamic var todoTitle = ""
    @objc dynamic var priority = false
    @objc dynamic var createdAt = Date()
    @objc dynamic var url: String = ""
    @objc dynamic var memo: String = ""
}
