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
        
        tableView.register(UINib(nibName: "TodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListTableViewCell")
        tableView.separatorColor = .none
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = todoList {
            return list.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
        cell.setItem(todoItem: todoList?[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // todo itemの詳細がみれるようにする
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategoryItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
        let todoRegistrationPopupViewController = TodoRegistrationPopupViewController.make()
        todoRegistrationPopupViewController.categoryId = self.categoryId

        let nav = UINavigationController(rootViewController: todoRegistrationPopupViewController)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

/// RealmSwift
private extension TodoListTableViewController {
    
    func initRealm() {
        // RealmのTodoリストを取得し，更新を監視
        realm = try! Realm()
        if categoryId == 0 {
            todoList = realm.objects(TodoItem.self).sorted(byKeyPath: "createdAt", ascending: true) // true-> 作成日古い順
        } else {
            todoList = realm.objects(TodoItem.self).filter("categoryId = %@", categoryId).sorted(byKeyPath: "createdAt", ascending: true) // true-> 作成日古い順
        }
        token = todoList.observe { [weak self] _ in
            self?.reload()
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
