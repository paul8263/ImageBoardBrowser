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
    @IBOutlet weak var websiteDetailLabel: UILabel!
    
    let sdImageCache = SDImageCache.shared()!
    let standardUserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.safeModeSwitch.isOn = standardUserDefaults.value(forKey: "safeMode") as? Bool ?? true
        self.safeModeSwitch.addTarget(self, action: #selector(safeModeSwitchValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.tableFooterView = UIView()
        setUserCacheLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setWebsiteDetailLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUserCacheLabel()
    }
    
    private func setUserCacheLabel() {
        let cacheSize = Double(sdImageCache.getSize()) / 1000000
        self.usedCacheLabel.text = String.init(format: "Used Cache: %.2f MB", cacheSize)
    }
    
    private func setWebsiteDetailLabel() {
        let website: Website = Website(rawValue: SettingsHelper.getWebsite())!
        switch website {
        case .Konachan:
            websiteDetailLabel.text = "Konachan"
        case .Yande:
            websiteDetailLabel.text = "Yande"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safeModeSwitchValueChanged(sender: UISwitch) {
        if !sender.isOn {
            let alertController = UIAlertController(title: "Attention", message: "Do you really want to switch off Safe Mode?", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { (action) in
                SettingsHelper.setSafeMode(isEnabled: sender.isOn)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                sender.setOn(true, animated: true)
            })
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            SettingsHelper.setSafeMode(isEnabled: sender.isOn)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            var alertController: UIAlertController!
            if UIDevice.current.userInterfaceIdiom == .phone {
                alertController = UIAlertController(title: "Delete Cache?", message: nil, preferredStyle: .actionSheet)
            } else {
                alertController = UIAlertController(title: "Delete Cache?", message: nil, preferredStyle: .alert)
            }
            
            let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.sdImageCache.clearDisk()
                self.setUserCacheLabel()
            })
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okAlertAction)
            alertController.addAction(cancelAlertAction)
            
            present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
