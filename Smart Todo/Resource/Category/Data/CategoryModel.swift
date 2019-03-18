//
//  CategoryModel.swift
//  Smart Todo
//
//  Created by Marie on 2019/02/19.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
import RealmSwift

// Category
class CategoryItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var categoryTitle = ""
    @objc dynamic var canDeleteFlg = false
    @objc dynamic var createdAt = Date()
    @objc dynamic var priority: Int = 3
    
    override static func primaryKey() -> String? {
        return "id"
    }
    let todo = List<TodoItem>()
    
    private func incrementId() -> Int {
        let realm = try! Realm()
        if let retNext = realm.objects(CategoryItem.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        } else {
            return 1
        }
    }
    
    /// カテゴリを全て取得する
    func categories() -> Results<CategoryItem> {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(CategoryItem.self).sorted(byKeyPath: "createdAt", ascending: true) // true-> 作成日古い順
    }
    
    func register(title: String, priority: Int) {// Todo: 後でBoolを返却しても良いかも
        let realm = try! Realm()
        try! realm.write {
            let id = self.incrementId()
            realm.add(CategoryItem(value: ["id": id,
                                           "categoryTitle": title,
                                           "priority": priority]))
        }
    }
    
    func edit(id: Int, title: String, beforeItem: CategoryItem) {
        let realm = try! Realm()
        let item = CategoryItem()
        item.id = id
        item.categoryTitle = title
        item.canDeleteFlg = beforeItem.canDeleteFlg
        item.createdAt = beforeItem.createdAt
        item.priority = beforeItem.priority
        item.createdAt = beforeItem.createdAt
        
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    func delete(category: CategoryItem) -> Results<CategoryItem>  {
        let realm = try! Realm()
        let result = realm.objects(CategoryItem.self).sorted(byKeyPath: "createdAt", ascending: true)
        try! realm.write {
            realm.delete(category)
        }
        return result
    }
}

class TodoItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var categoryId = 0
    @objc dynamic var todoTitle = ""
    @objc dynamic var priority: Int = 3
    @objc dynamic var createdAt = Date()
    @objc dynamic var deadlineDate: Date? = nil
    @objc dynamic var url: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var doneFlg: Bool = false
    
    let category = LinkingObjects(fromType: CategoryItem.self, property: "todo")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementId() -> Int {
        let realm = try! Realm()
        if let retNext = realm.objects(TodoItem.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        } else {
            return 1
        }
    }
    
    /// 全てのtodoItemsを取得する
    func allTodoItems() -> Results<TodoItem> {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    /// 全てのtodoItemsのカウントを取得する
    func allCount() -> Int {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).count
    }
    
    /// 完了済みitemを全て取得する
    func allCheckCount() -> Int {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("doneFlg = %@", true).count
    }
    
    /// categoryの持つitem数を取得する
    func categoryItemCount(categoryId: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).count
    }
    
    /// 完了済みitemを取得する
    func checkCount(categoryId: Int) -> Int {
        let realm = try! Realm()
        let item = realm.objects(TodoItem.self).filter("categoryId = %@", categoryId)
        return item.filter("doneFlg = %@", true).count
    }
    
    /// categoryを指定してtodoItemを取得する
    func todoItems(categoryId: Int) -> Results<TodoItem> {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func todoItem(id: Int) -> Results<TodoItem> {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("id = %@", id)
    }
    
    /// todoItemの完了フラグを更新する
    public func changeDoneFlg(beforeItem: TodoItem, flg: Bool) {
        let realm = try! Realm()
        let item = TodoItem()
        item.id = beforeItem.id
        item.doneFlg = flg
        
        item.categoryId = beforeItem.categoryId
        item.todoTitle = beforeItem.todoTitle
        item.priority = beforeItem.priority
        item.createdAt = beforeItem.createdAt
        item.url = beforeItem.url
        item.memo = beforeItem.memo
        
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    /// todoItemの各データを修正する
    public func updateItem(beforeItem: TodoItem) {
        let realm = try! Realm()
        let item = TodoItem()
        item.id = beforeItem.id
        item.doneFlg = beforeItem.doneFlg
        item.categoryId = beforeItem.categoryId
        item.todoTitle = beforeItem.todoTitle
        item.priority = beforeItem.priority
        item.createdAt = beforeItem.createdAt
        item.url = beforeItem.url
        item.memo = beforeItem.memo
        
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    /// todoItemの削除
    func deleteItem(categoryId: Int, todoId: Int)  -> Results<TodoItem>  {
        let realm = try! Realm()
        let categoryResults = realm.objects(CategoryItem.self).filter("id = %@", categoryId).first
        let item = categoryResults?.todo.filter("id = %@", todoId).first
        
        let todoResults = realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).sorted(byKeyPath: "createdAt", ascending: false)

        if let deleteItem = item {
            try! realm.write {
                realm.delete(deleteItem)
            }
        }
        return todoResults
    }
    
    /// Category内の全てのItemを削除
    func deleteItemInCategory(categoryId: Int) {
        let realm = try! Realm()
        let category = realm.objects(CategoryItem.self).filter("id = %@", categoryId).first
        let item = category?.todo.filter("categoryId = %@", categoryId)
        
        if let deleteItem = item {
            try! realm.write {
                realm.delete(deleteItem)
            }
        }
    }
}
