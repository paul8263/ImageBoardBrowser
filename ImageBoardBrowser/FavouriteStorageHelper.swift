//
//  FavouriteStorageHelper.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 5/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation

class FavouriteStorageHelper {
    static func loadFavouriteList() -> [ImageInfo] {
        var imageInfoList: [ImageInfo] = []
        if let favouriteDataArray = UserDefaults.standard.object(forKey: "favourite") as? [Data] {
            for favouriteData in favouriteDataArray {
                let imageInfo = NSKeyedUnarchiver.unarchiveObject(with: favouriteData) as! ImageInfo
                imageInfoList.append(imageInfo)
            }
        }
        return imageInfoList
    }
    static func addToFavouriteList(imageInfo: ImageInfo) {
        if !isExisting(imageInfo: imageInfo) {
            let favouriteData = NSKeyedArchiver.archivedData(withRootObject: imageInfo)
            if var favouriteDataArray = UserDefaults.standard.object(forKey: "favourite") as? [Data] {
                favouriteDataArray.append(favouriteData)
                UserDefaults.standard.set(favouriteDataArray, forKey: "favourite")
            } else {
                let favouriteDataArray: [Data] = [favouriteData]
                UserDefaults.standard.set(favouriteDataArray, forKey: "favourite")
            }
        }
    }
    
    static func removeOneFromFavouriteList(imageInfo: ImageInfo) {
        var imageInfoList = loadFavouriteList()
        for i in 0 ..< imageInfoList.count {
            if imageInfoList[i].id == imageInfo.id {
                imageInfoList.remove(at: i)
                break
            }
        }
        setFavouriteList(imageInfoList: imageInfoList)
    }
    
    static func setFavouriteList(imageInfoList: [ImageInfo]) {
        var favouriteDataArray: [Data] = []
        for imageInfo in imageInfoList {
            let favouriteData = NSKeyedArchiver.archivedData(withRootObject: imageInfo)
            favouriteDataArray.append(favouriteData)
        }
        UserDefaults.standard.set(favouriteDataArray, forKey: "favourite")
    }
    
    static func isExisting(imageInfo: ImageInfo) -> Bool {
        let imageInfoList = loadFavouriteList()
        for item in imageInfoList {
            if item.id == imageInfo.id {
                return true
            }
        }
        return false
    }
    
    static func addFavouriteTag(tag: String) {
        if var favouriteTags = UserDefaults.standard.array(forKey: "favouriteTags") as? [String] {
            if !favouriteTags.contains(tag) {
                favouriteTags.append(tag)
                setFavouriteTags(tags: favouriteTags)
            }
        } else {
            let favouriteTags = [tag]
            setFavouriteTags(tags: favouriteTags)
        }
    }
    
    static func loadFavouriteTags() -> [String] {
        if let favouriteTags = UserDefaults.standard.array(forKey: "favouriteTags") as? [String] {
            return favouriteTags
        } else {
            return [String]()
        }
    }
    
    static func setFavouriteTags(tags: [String]) {
        UserDefaults.standard.set(tags, forKey: "favouriteTags")
    }
}
