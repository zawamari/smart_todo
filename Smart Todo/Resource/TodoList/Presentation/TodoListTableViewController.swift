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
    
    private var tableViewData: TodoListTableViewData = TodoListTableViewData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRealm()

        // NavigationBar Setting
        self.title = navigationTitle
        
        let button: UIBarButtonItem = UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(back))
        self.navigationItem.setLeftBarButtonItems([button], animated: true)
        
        tableView.register(UINib(nibName: "TodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListTableViewCell")
        tableView.register(UINib(nibName: "CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateTableViewCell")
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.rowCount(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = tableViewData.cellType(index: indexPath)
        switch cellType {
        case .todo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
            
            cell.setItem(todoItem: todoList[indexPath.row])
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        case .create:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateTableViewCell", for: indexPath) as! CreateTableViewCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableViewData.cellType(index: indexPath)
        switch cellType {
        case .todo:
            // そのうち詳細モーダルを出したい
            break
        case .create:
            clickCreateCategoryButton()
        }
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
    
    /// Create New todo item
    func clickCreateCategoryButton(){
        let todoRegistrationPopupViewController = TodoRegistrationPopupViewController.make()
        todoRegistrationPopupViewController.categoryId = self.categoryId

        let nav = UINavigationController(rootViewController: todoRegistrationPopupViewController)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension TodoListTableViewCell: TodoListTableViewCellDelegate {
    func tapCheckImage(item: TodoItem, flg: Bool) {
        TodoItem().changeDoneFlg(beforeItem: item, flg: flg)
    }
}

/// RealmSwift
private extension TodoListTableViewController {
    
    func initRealm() {
        // RealmのTodoリストを取得し，更新を監視
        realm = try! Realm()
        if categoryId == 0 {
            todoList = TodoItem().allTodoItems()
        } else {
            todoList = TodoItem().todoItems(categoryId: categoryId)
        }
        token = todoList.observe { [weak self] _ in
            self?.tableViewData.refresh(model: self?.todoList.count)
            self?.reload()
        }
    }
    
    func deleteCategoryItem(at index: Int) {
        TodoItem().deleteItem(categoryId: categoryId, todoId: todoList[index].id)
    }
}
