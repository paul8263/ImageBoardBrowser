//
//  FavourateStorageHelper.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 5/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation

class FavourateStorageHelper {
    static func loadFavourateList() -> [ImageInfo] {
        var imageInfoList: [ImageInfo] = []
        if let favourateDataArray = UserDefaults.standard.object(forKey: "favourate") as? [Data] {
            for favourateData in favourateDataArray {
                let imageInfo = NSKeyedUnarchiver.unarchiveObject(with: favourateData) as! ImageInfo
                imageInfoList.append(imageInfo)
            }
        }
        return imageInfoList
    }
    static func addToFavourateList(imageInfo: ImageInfo) {
        if !isExisting(imageInfo: imageInfo) {
            let favourateData = NSKeyedArchiver.archivedData(withRootObject: imageInfo)
            if var favourateDataArray = UserDefaults.standard.object(forKey: "favourate") as? [Data] {
                favourateDataArray.append(favourateData)
                UserDefaults.standard.set(favourateDataArray, forKey: "favourate")
            } else {
                let favourateDataArray: [Data] = [favourateData]
                UserDefaults.standard.set(favourateDataArray, forKey: "favourate")
            }
        }
    }
    
    static func removeOneFromFavourateList(imageInfo: ImageInfo) {
        var imageInfoList = loadFavourateList()
        for i in 0 ..< imageInfoList.count {
            if imageInfoList[i].id == imageInfo.id {
                imageInfoList.remove(at: i)
            }
        }
        setFavourateList(imageInfoList: imageInfoList)
    }
    
    static func setFavourateList(imageInfoList: [ImageInfo]) {
        var favourateDataArray: [Data] = []
        for imageInfo in imageInfoList {
            let favourateData = NSKeyedArchiver.archivedData(withRootObject: imageInfo)
            favourateDataArray.append(favourateData)
        }
        UserDefaults.standard.set(favourateDataArray, forKey: "favourate")
    }
    
    static func isExisting(imageInfo: ImageInfo) -> Bool {
        let imageInfoList = loadFavourateList()
        for item in imageInfoList {
            if item.id == imageInfo.id {
                return true
            }
        }
        return false
    }
}
