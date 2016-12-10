//
//  WebsiteSwitchingTableViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 10/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class WebsiteSwitchingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            SettingsHelper.setWebsite(website: .Konachan)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            SettingsHelper.setWebsite(website: .Yande)
        }
        navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let website = Website(rawValue: SettingsHelper.getWebsite())!
        switch website {
        case .Konachan:
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            }
        case .Yande:
            if indexPath.row == 1 {
                cell.accessoryType = .checkmark
            }
        }
    }
}
