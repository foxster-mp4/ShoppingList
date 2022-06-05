//
//  ViewController.swift
//  ShoppingList
//
//  Created by Huy Bui on 2022-06-05.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // App title
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Top buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        
        // Clear button
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearShoppingList))
        clearButton.tintColor = .red
        toolbarItems = [space, clearButton, space]
        navigationController?.isToolbarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    // Swipe to delete
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {[weak self] _,_,_ in
//            self?.shoppingList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        deleteAction.backgroundColor = .red
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
    
    // Swipe to delete (thanks to @TwoStraws)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    @objc func addShoppingItem() {
        let alertController = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Add", style: .default) {[weak alertController, weak self] _ in
            guard let item = alertController?.textFields?[0].text else { return }
            if item.isEmpty { return }
            
            self?.shoppingList.insert(item, at: 0)
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        })
        present(alertController, animated: true)
    }
    
    @objc func shareShoppingList() {
        if shoppingList.count == 0 {
            let alertController = UIAlertController(title: nil, message: "Please add an item before sharing", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default))
            present(alertController, animated: true)
            
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [outputShoppingList()], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(activityViewController, animated: true)
    }

    @objc func clearShoppingList() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to clear the shopping list?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Clear", style: .destructive) {[weak self] _ in
            self?.shoppingList.removeAll()
            self?.tableView.reloadData()
        })
        present(alertController, animated: true)
    }
    
    func outputShoppingList() -> String {
        var tempList = shoppingList; tempList.insert("Shopping list:", at: 0)
        let shoppingListString = tempList.joined(separator: "\n")
        return shoppingListString
    }

}
