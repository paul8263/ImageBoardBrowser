//
//  FavouriteTagsTableViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 29/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

private let reusableIdentifier = "FavouriteTagCell"

class FavouriteTagsTableViewController: UITableViewController {
    
    var favouriteTags: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.hidesBarsOnSwipe = false
        
        tableView.tableFooterView = UIView()
    }
    
    private func loadData() {
        favouriteTags = FavouriteStorageHelper.loadFavouriteTags()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favouriteTags.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = favouriteTags[indexPath.row]
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favouriteTags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            FavouriteStorageHelper.setFavouriteTags(tags: favouriteTags)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabBarController = self.tabBarController
        
        let navigationController = tabBarController?.viewControllers?[2] as? UINavigationController
        _ = navigationController?.popToRootViewController(animated: false)
        let searchViewController = navigationController?.topViewController as! SearchViewController
        searchViewController.searchedTags = favouriteTags[indexPath.row]
        searchViewController.searchBar.text = searchViewController.searchedTags
        searchViewController.performSearch()
        tabBarController?.selectedIndex = 2
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
