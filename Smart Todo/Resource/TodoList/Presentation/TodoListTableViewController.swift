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
    var categoryId: Int?
    
    private var realm: Realm!
    private var todoList: Results<TodoItem>!
    private var token: NotificationToken!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RealmのTodoリストを取得し，更新を監視
        realm = try! Realm()
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        todoList = realm.objects(TodoItem.self).sorted(byKeyPath: "createdAt", ascending: true) // true-> 作成日古い順
        token = todoList.observe { [weak self] _ in
            self?.reload()
        }

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

        cell.textLabel?.text = "This cell is " + String(indexPath.row)
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    func addTodoItem(title: String) {
        try! realm.write {
            realm.add(TodoItem(value: ["todoTitle": title]))
        }
    }
    
    func deleteCategoryItem(at index: Int) {
        try! realm.write {
            realm.delete(todoList[index])
        }
    }
    
}
