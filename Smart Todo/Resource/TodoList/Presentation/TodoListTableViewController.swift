//
//  TodoListTableViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/26.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    let todo = ["check list","send mail","create new project"]
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Create New Category
    @objc func clickCreateCategoryButton(){
        let alert: UIAlertController = UIAlertController(title: "Category Create?", message: "What is new category name?", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
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

        // NavigationBar Setting
        self.title = "Work Todo List"
        
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
        return todo.count
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

}
