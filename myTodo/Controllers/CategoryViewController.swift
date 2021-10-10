//
//  ViewController.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    private var addButton: FloatingButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let defaults = UserDefaults.standard
    
    let realm = try! Realm()//try!の意味は後で調べる（!はつけた方が良いときとそうでない時があるみたい）
    
    var categories: Results<Category>?//RealmSwiftはResults型を扱う（listやarrayのようなもの,queryでrealmdatabaseからdataを取得する際はresults型を利用）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        addButton = FloatingButton(attachedToView: self.view)
        addButton.floatButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }

        //navBar.barTintColor = UIColor(hexString: "0A84FF")
        //navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]//navbarのtitleのcolorを変更
        navBar.barTintColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
        addButton.floatButton.layer.backgroundColor = (defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()).cgColor

        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //nilだったら1を返す
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SwipeTableViewCell

        cell.delegate = self
        
        
        
        //swipeTableViewControllerよりtableView(cellForRowAt)のcellを継承
        // let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {

            cell.textLabel?.text = category.name
        }

        
        return cell
        
    }

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.categoryToItemSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //カテゴリセルを押したときの処理
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = categories?[indexPath.row]
        }        
    }
    
    //MARK: - Data Manupulation Methods
    private func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "orderOfCategory")
                
        tableView.reloadData()
    }
    
    //MARK: - Delete Data Method
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category.items)//relationalなdataも除去
                    realm.delete(category)
                }
            } catch {
                print("Error deleting the category, \(error)")
            }
        }
    }
    
    //MARK: - Editing Cell Method in Realm
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //move cell in Editing mode
        do {
            try realm.write {
                let sourceCategory = categories?[sourceIndexPath.row]
                let destinationCategory = categories?[destinationIndexPath.row]
                
                let destinationCategoryOrder = destinationCategory?.orderOfCategory
                
                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in sourceIndexPath.row ... destinationIndexPath.row {
                        categories?[index].orderOfCategory -= 1
                    }
                } else {
                    for index in (destinationIndexPath.row ..< sourceIndexPath.row).reversed() {
                        categories?[index].orderOfCategory += 1
                    }
                }
                
                guard let destOrder = destinationCategoryOrder else {
                    fatalError("destinationCategoryOrder does not exist")
                }
                sourceCategory?.orderOfCategory = destOrder
            }
        } catch {
            print("Error moving the cell, \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //delete cell in Editing mode
        if editingStyle == .delete {
            updateModel(at: indexPath)
            loadCategories()
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
        
    //MARK: - Add New Categories

    @objc private func addButtonPressed(_ sender: FloatingButton) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in

            let newCategory = Category()//coredataと違ってcontextはいらない
            newCategory.name = textField.text!

            if let count = self.categories?.count {
                newCategory.orderOfCategory = count
            }

            self.save(category: newCategory)

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }

        present(alert, animated: true, completion: nil)

    }
}
