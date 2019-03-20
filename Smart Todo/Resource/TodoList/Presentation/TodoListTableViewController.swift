//
//  TodoListTableViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/26.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var navigationTitle: String? = nil
    var categoryId: Int = 0
    
    private var realm: Realm!
    private var category: Results<CategoryItem>!
    private var todoList: Results<TodoItem>!
    private var token: NotificationToken!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var sortImageView: UIImageView!
    
    private var tableViewData: TodoListTableViewData = TodoListTableViewData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initRealm()
        // NavigationBar Setting
        self.title = navigationTitle
        let button: UIBarButtonItem = UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(backBtn))
        self.navigationItem.setLeftBarButtonItems([button], animated: true)

        tableView.register(UINib(nibName: "TodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListTableViewCell")
        tableView.register(UINib(nibName: "CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateTableViewCell")
        tableView.register(UINib(nibName: "TodoNoneTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoNoneTableViewCell")
        tableView.separatorStyle = .none
        
        backImageView.image = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
        let back = UITapGestureRecognizer(target: self, action: #selector(back(_:)))
        backImageView.addGestureRecognizer(back)
        
        
        let add = UITapGestureRecognizer(target: self, action: #selector(clickCreateCategoryButton(_:)))
        addImageView.addGestureRecognizer(add)
        addImageView.image = UIImage.fontAwesomeIcon(name: .plusCircle, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
        
        sortImageView.image = UIImage.fontAwesomeIcon(name: .sortNumericDown, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.rowCount(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        case .none:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoNoneTableViewCell", for: indexPath) as! TodoNoneTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableViewData.cellType(index: indexPath)
        switch cellType {
        case .todo:
            buttonDidTap(index: indexPath.row)
        case .create, .none:
            createNewTodo()
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cellType = tableViewData.cellType(index: indexPath)
        switch cellType {
        case .todo:
            if editingStyle == .delete {
                deleteCategoryItem(at: indexPath.row)
  //            tableView.deleteRows(at: [indexPath], with: .fade)//fade かけたいけどクラッシュする
            }
        case .create, .none:
            break
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func reload() {
        tableView.reloadData()
    }

}

extension TodoListTableViewController {
    static func make() -> TodoListTableViewController {
        let storyboard = UIStoryboard(name: "TodoList", bundle: nil)
        return storyboard.instantiateInitialViewController() as! TodoListTableViewController
    }
}


private extension TodoListTableViewController {
    func buttonDidTap(index: Int) {
        let vc = TodoDetailAndEditViewController.make()
        vc.categoryId = todoList[index].categoryId
        vc.todoId = todoList[index].id
        present(vc, animated: true, completion: nil)
    }
    
    @objc func backBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func back(_: UIGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Create New todo item
    @objc func clickCreateCategoryButton(_: UIGestureRecognizer){
        createNewTodo()
    }
    
    func createNewTodo() {
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
        // このcategoryIdは削除したいtodoのカテゴリ
        todoList = TodoItem().deleteItem(categoryId: todoList[index].categoryId, todoId: todoList[index].id)
    }
}
