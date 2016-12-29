//
//  ImageTagsTableViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 10/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class ImageTagsTableViewController: UITableViewController {
    
    var imageTagArray: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = tabBarController as? MainTabBarController {
            tabBarController.panGesture?.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = tabBarController as? MainTabBarController {
            tabBarController.panGesture?.isEnabled = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageTagArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageTagCell", for: indexPath)
        cell.textLabel?.text = imageTagArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let tabBarController = self.tabBarController
        
        let navigationController = tabBarController?.viewControllers?[2] as? UINavigationController
        _ = navigationController?.popToRootViewController(animated: false)
        let searchViewController = navigationController?.topViewController as! SearchViewController
        searchViewController.searchedTags = imageTagArray[indexPath.row]
        searchViewController.searchBar.text = searchViewController.searchedTags
        searchViewController.performSearch()
        tabBarController?.selectedIndex = 2
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToFavouriteAction = UITableViewRowAction(style: .default, title: "Add") { (action, indexPath) in
            FavouriteStorageHelper.addFavouriteTag(tag: self.imageTagArray[indexPath.row])
            self.tableView.setEditing(false, animated: true)
        }
        addToFavouriteAction.backgroundColor = UIColor.orange
        return [addToFavouriteAction]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
