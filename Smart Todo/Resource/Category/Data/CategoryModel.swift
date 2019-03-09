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
    @objc dynamic var priority = false
    
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
    
    func register(title: String, priority: Bool) {// Todo: 後でBoolを返却しても良いかも
        let realm = try! Realm()
        try! realm.write {
            let id = self.incrementId()
            realm.add(CategoryItem(value: ["id": id,
                                           "categoryTitle": title,
                                           "priority": priority]))
        }
    }
    
    func delete(category: CategoryItem) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(category)
        }
    }
}

class TodoItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var categoryId = 0
    @objc dynamic var todoTitle = ""
    @objc dynamic var priority = false
    @objc dynamic var createdAt = Date()
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
        return realm.objects(TodoItem.self).sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    /// 全てのtodoItemsのカウントを取得する
    func allCount() -> Int {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).count
    }
    
    func categoryItemCount(categoryId: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).count
    }
    
    /// categoryを指定してtodoItemを取得する
    func todoItems(categoryId: Int) -> Results<TodoItem> {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).sorted(byKeyPath: "createdAt", ascending: true)
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
    func deleteItem(categoryId: Int, todoId: Int) {
        let realm = try! Realm()
        let category = realm.objects(CategoryItem.self).filter("id = %@", categoryId).first
        let item = category?.todo.filter("id = %@", todoId).first
        
        if let deleteItem = item {
            try! realm.write {
                realm.delete(deleteItem)
            }
        }
    }
    
    /// Category内の全てのItemを削除
}
