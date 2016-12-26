//
//  ImageInfoTableViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 10/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class ImageInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!    
    @IBOutlet weak var authorLabel: UILabel!    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    
    var imageInfo: ImageInfo!

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayData()
        tableView.tableFooterView = UIView()
    }
    
    private func displayData() {
        previewImageView.sd_setImage(with: imageInfo.getPreviewURL())
        authorLabel.text = imageInfo.author
        scoreLabel.text = "\(imageInfo.score)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let formatterDateString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(imageInfo.createdAt)))
        createDateLabel.text = formatterDateString
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 1 {
            let tagArray = imageInfo.tags.components(separatedBy: " ")
            performSegue(withIdentifier: "showImageTags", sender: tagArray)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageTags" {
            let imageTagsTableViewController = segue.destination as! ImageTagsTableViewController
            imageTagsTableViewController.imageTagArray = sender as! [String]
        }
    }

}
