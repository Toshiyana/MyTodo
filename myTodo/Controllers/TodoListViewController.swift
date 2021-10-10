//
//  TodoListViewController.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    private var addButton: FloatingButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton = FloatingButton(attachedToView: self.view)
        addButton.floatButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        //title = selectedCategory?.name//navigationControllerをいじらず，titleだけを変えるならこっちの方が良い？
    }
    
    //画面に表示される直前
    //viewDidLoad()ではnavigationControllerは生成されておらず，navigationControllerを用いる場合，表示直前のviewWillAppear()を用いる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)//lifecycle methodではsuperで継承
        
        if let categoryName = selectedCategory?.name {

            title = categoryName//navbarのタイトルをカテゴリ名に設定

            guard let navBar = navigationController?.navigationBar else {
                fatalError("NavigationController does not exist.")
            }

            
//            if let navBarColor = UIColor(hexString: colorHex) {
//                navBar.barTintColor = navBarColor
//                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)//navbarのback，buttonの色を変更
//                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]//navbarのtitleのcolorを変更
//
//
//            }
        }
    }
    
    
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SwipeTableViewCell

        cell.delegate = self

        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
        
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)//tapした時にitemの除去
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }

        tableView.reloadData()
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Delete Data Method
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting the item, \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    @objc private func addButtonPressed(_ sender: FloatingButton) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item, \(error)")
                }
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        let canelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(canelAction)

        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manupulation Method
    func loadItems() {

//        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        todoItems = selectedCategory?.items.sorted(byKeyPath: "orderOfItem")
        
        tableView.reloadData()

    }
    
    
    //MARK: - Editing Cell Method in Realm
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //move cell in Editing mode
        do {
            try realm.write {
                let sourceCategory = todoItems?[sourceIndexPath.row]
                let destinationCategory = todoItems?[destinationIndexPath.row]
                
                let destinationCategoryOrder = destinationCategory?.orderOfItem
                
                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in sourceIndexPath.row ... destinationIndexPath.row {
                        todoItems?[index].orderOfItem -= 1
                    }
                } else {
                    for index in (destinationIndexPath.row ..< sourceIndexPath.row).reversed() {
                        todoItems?[index].orderOfItem += 1
                    }
                }
                
                guard let destOrder = destinationCategoryOrder else {
                    fatalError("destinationCategoryOrder does not exist")
                }
                sourceCategory?.orderOfItem = destOrder
            }
        } catch {
            print("Error moving the cell, \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //delete cell in Editing mode
        if editingStyle == .delete {
            updateModel(at: indexPath)
            loadItems()
        }
    }
        
    //MARK: - Edit Button Methods
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

        if tableView.isEditing {
            tableView.isEditing = false
            editButton.title = "Edit"
            addButton.floatButton.isHidden = false

        } else {
            tableView.isEditing = true
            editButton.title = "Done"
            addButton.floatButton.isHidden = true

        }

    }
}
