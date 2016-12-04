//
//  SettingsViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsViewController: UITableViewController {
    @IBOutlet weak var usedCacheLabel: UILabel!
    @IBOutlet weak var safeModeSwitch: UISwitch!
    
    let sdImageCache = SDImageCache.shared()!
    let standardUserDefaults = UserDefaults.standard
    
    var isSafeModeEnabled = true
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.safeModeSwitch.isOn = isSafeModeEnabled
        self.safeModeSwitch.addTarget(self, action: #selector(safeModeSwitchValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cacheSize = sdImageCache.getSize() / 1000000
        self.usedCacheLabel.text = "Used cache: \(cacheSize) MB"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safeModeSwitchValueChanged(sender: UISwitch) {
        print(sender.isOn)
        standardUserDefaults.set(sender.isOn, forKey: "safeMode")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
