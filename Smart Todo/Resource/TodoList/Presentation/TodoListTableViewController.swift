//
//  TodoListTableViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/26.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController {
    
    var navigationTitle: String? = nil
    var categoryId: Int = 0
    
    private var realm: Realm!
    private var category: Results<CategoryItem>!
    private var todoList: Results<TodoItem>!
    private var token: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRealm()

        // NavigationBar Setting
        self.title = navigationTitle
        
        let button: UIBarButtonItem = UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(back))
        self.navigationItem.setLeftBarButtonItems([button], animated: true)

        let createButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickCreateCategoryButton))
        
        self.navigationItem.setRightBarButtonItems([createButton], animated: true)
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "test")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = todoList {
            return list.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
        
        if let title = todoList?[indexPath.row].todoTitle {
            cell.textLabel?.text = title
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategoryItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func reload() {
        tableView.reloadData()
    }

}

private extension TodoListTableViewController {
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Create New Category
    @objc func clickCreateCategoryButton(){
        let alert: UIAlertController = UIAlertController(title: "todo Create", message: "What is new todo name?", preferredStyle:  UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: nil)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if let t = alert.textFields![0].text, !t.isEmpty {
                self.addTodoItem(title: t)
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}

/// RealmSwift
private extension TodoListTableViewController {
    
    func initRealm() {
        // RealmのTodoリストを取得し，更新を監視
        realm = try! Realm()
        todoList = realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).sorted(byKeyPath: "createdAt", ascending: true) // true-> 作成日古い順
        token = todoList.observe { [weak self] _ in
            self?.reload()
        }
    }
    
    func addTodoItem(title: String) {
        
        if let category = navigationTitle {
            let realm = try! Realm()

            // titleから登録したい親カテゴリを抽出
            let dept = realm.objects(CategoryItem.self).filter("categoryTitle == '\(category)'").first
            
            // todolistのセット
            let emp = TodoItem()
            emp.todoTitle = title
            emp.priority = true
            emp.categoryId = self.categoryId
            emp.id = emp.incrementId()
            
            // 登録
            try! realm.write {
                dept?.todo.append(emp)
            }
        }

    }
    
    func deleteCategoryItem(at index: Int) {
            // 子データの削除
        if let category = navigationTitle {
            let realm = try! Realm()
            let dept = realm.objects(CategoryItem.self).filter("categoryTitle == '\(category)'").first
            let emp = dept?.todo.filter("todoTitle == '\(todoList[index].todoTitle)'").first
            
            try! realm.write {
                realm.delete(emp!)
            }
        }
    }
}
