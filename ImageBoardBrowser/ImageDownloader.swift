//
//  ImageDownloader.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import AFNetworking
import UIKit

class ImageDownloader {
    private static let manager = AFURLSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
    
    private static func downloadWithURL(url: URL, completionHandler: @escaping (_ imageInfoList: [ImageInfo]) -> Void, failureHandler: ((_ error: Error) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = manager.dataTask(with: request, completionHandler: {(response, responseObject, error) -> Void in
            if (error != nil) {
                failureHandler?(error!)
            }
            let imageInfoList = convertResponseObjectToImageInfoList(responseObject: responseObject)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completionHandler(imageInfoList)
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume();
    }
    
    private static func convertResponseObjectToImageInfoList(responseObject: Any?) -> [ImageInfo] {
        var imageInfoList: [ImageInfo] = []
        if let responseArray = responseObject as? Array<[String: Any]> {
            for item in responseArray {
                let imageInfo = ImageInfo(fromDict: item)
                imageInfoList.append(imageInfo)
            }
        }
        return imageInfoList
    }
    
    static func downloadImages(withPage: Int, completionHandler: @escaping (_ imageInfoList: [ImageInfo]) -> Void, failureHandler: ((_ error: Error) -> Void)?) {
        let defaultTag = SettingsHelper.getSafeMode() ? "rating:s" : ""
        let urlString = "\(SettingsHelper.getWebsite())/post.json?tags=\(defaultTag)&page=\(withPage)&limit=20".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        let url = URL(string: urlString)!
        downloadWithURL(url: url, completionHandler: completionHandler, failureHandler: failureHandler)
    }
    
    static func downloadImages(withTags: String, withPage: Int, completionHandler: @escaping (_ imageInfoList: [ImageInfo]) -> Void, failureHandler: ((_ error: Error) -> Void)?) {
        let defaultTag = SettingsHelper.getSafeMode() ? "rating:s+" : ""
        let urlString = "\(SettingsHelper.getWebsite())/post.json?tags=\(defaultTag)\(withTags)&page=\(withPage)&limit=20".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        let url = URL(string: urlString)!
        downloadWithURL(url: url, completionHandler: completionHandler, failureHandler: failureHandler)
    }
}
