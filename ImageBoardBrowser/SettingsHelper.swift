//
//  SettingsHelper.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 10/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation

class SettingsHelper {
    static func setSafeMode(isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "safeMode")
        UserDefaults.standard.synchronize()
    }
    
    static func getSafeMode() -> Bool {
        return UserDefaults.standard.value(forKey: "safeMode") as! Bool? ?? true
    }
    
    static func setWebsite(website: Website) {
        UserDefaults.standard.set(website.rawValue, forKey: "website")
        UserDefaults.standard.synchronize()
    }
    static func getWebsite() -> String {
        return (UserDefaults.standard.value(forKey: "website") as? String ?? Website.Konachan.rawValue)!
    }
}

enum Website: String {
    case Konachan = "https://konachan.com"
    case Yande = "https://yande.re"
}
