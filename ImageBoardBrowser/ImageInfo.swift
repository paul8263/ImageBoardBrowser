//
//  ImageInfo.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation

class ImageInfo: NSObject, NSCoding {
    
    var id: Int = 0
    var tags: String = ""
    var createdAt: Int = 0
    var creatorId: Int?
    var author: String = ""
    var change: Int = 0
    var source: String = ""
    var score: Int = 0
    var md5: String = ""
    var fileSize: Int = 0
    var fileUrl: String = ""
    var isShownInIndex: Bool = false
    var previewUrl: String = ""
    var previewWidth: Int = 0
    var previewHeight: Int = 0
    var actualPreviewWidth: Int = 0
    var actualPreviewHeight: Int = 0
    var sampleUrl: String = ""
    var sampleWidth: Int = 0
    var sampleHeight: Int = 0
    var sampleFileSize: Int = 0
    var jpegUrl: String = ""
    var jpegWidth: Int = 0
    var jpegHeight: Int = 0
    var jpegFileSize: Int = 0
    var rating: String = ""
    var hasChildren: Bool = false
    var parentId: Int?
    var status: String = ""
    var width: Int = 0
    var height: Int = 0
    var isHeld: Bool = false
    var flagDetail: String?
    
    init(fromDict: [String: Any]) {
        self.id = fromDict["id"] as! Int
        self.tags = fromDict["tags"] as! String
        self.createdAt = fromDict["created_at"] as! Int
        self.creatorId = fromDict["creator_id"] as? Int
        self.author = fromDict["author"] as! String
        self.change = fromDict["change"] as! Int
        self.source = fromDict["source"] as! String
        self.score = fromDict["score"] as! Int
        self.md5 = fromDict["md5"] as! String
        self.fileSize = fromDict["file_size"] as! Int
        self.fileUrl = fromDict["file_url"] as! String
        self.isShownInIndex = fromDict["is_shown_in_index"] as! Bool
        self.previewUrl = fromDict["preview_url"] as! String
        self.previewWidth = fromDict["preview_width"] as! Int
        self.previewHeight = fromDict["preview_height"] as! Int
        self.actualPreviewWidth = fromDict["actual_preview_width"] as! Int
        self.actualPreviewHeight = fromDict["actual_preview_height"] as! Int
        self.sampleUrl = fromDict["sample_url"] as! String
        self.sampleWidth = fromDict["sample_width"] as! Int
        self.sampleHeight = fromDict["sample_height"] as! Int
        self.sampleFileSize = fromDict["sample_file_size"] as! Int
        self.jpegUrl = fromDict["jpeg_url"] as! String
        self.jpegWidth = fromDict["jpeg_width"] as! Int
        self.jpegHeight = fromDict["jpeg_height"] as! Int
        self.jpegFileSize = fromDict["jpeg_file_size"] as! Int
        self.rating = fromDict["rating"] as! String
        self.hasChildren = fromDict["has_children"] as! Bool
        self.parentId = fromDict["parent_id"] as? Int
        self.status = fromDict["status"] as! String
        self.width = fromDict["width"] as! Int
        self.height = fromDict["height"] as! Int
        self.isHeld = fromDict["is_held"] as! Bool
        self.flagDetail = fromDict["flag_detail"] as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.creatorId, forKey: "creatorId")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.change, forKey: "change")
        aCoder.encode(self.source, forKey: "source")
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.md5, forKey: "md5")
        aCoder.encode(self.fileSize, forKey: "fileSize")
        aCoder.encode(self.fileUrl, forKey: "fileUrl")
        aCoder.encode(self.isShownInIndex, forKey: "isShownInIndex")
        aCoder.encode(self.previewUrl, forKey: "previewUrl")
        aCoder.encode(self.previewWidth, forKey: "previewWidth")
        aCoder.encode(self.previewHeight, forKey: "previewHeight")
        aCoder.encode(self.actualPreviewWidth, forKey: "actualPreviewWidth")
        aCoder.encode(self.actualPreviewHeight, forKey: "actualPreviewHeight")
        aCoder.encode(self.sampleUrl, forKey: "sampleUrl")
        aCoder.encode(self.sampleWidth, forKey: "sampleWidth")
        aCoder.encode(self.sampleHeight, forKey: "sampleHeight")
        aCoder.encode(self.sampleFileSize, forKey: "sampleFileSize")
        aCoder.encode(self.jpegUrl, forKey: "jpegUrl")
        aCoder.encode(self.jpegWidth, forKey: "jpegWidth")
        aCoder.encode(self.jpegHeight, forKey: "jpegHeight")
        aCoder.encode(self.jpegFileSize, forKey: "jpegFileSize")
        aCoder.encode(self.rating, forKey: "rating")
        aCoder.encode(self.hasChildren, forKey: "hasChildren")
        aCoder.encode(self.parentId, forKey: "parentId")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.width, forKey: "width")
        aCoder.encode(self.height, forKey: "height")
        aCoder.encode(self.isHeld, forKey: "isHeld")
        aCoder.encode(self.flagDetail, forKey: "flagDetail")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.tags = aDecoder.decodeObject(forKey: "tags") as! String
        self.createdAt = aDecoder.decodeInteger(forKey: "createdAt")
        if aDecoder.containsValue(forKey: "creatorId") {
            self.creatorId = aDecoder.decodeObject(forKey: "creatorId") as? Int
        }
        self.author = aDecoder.decodeObject(forKey: "author") as! String
        self.change = aDecoder.decodeInteger(forKey: "change")
        self.source = aDecoder.decodeObject(forKey: "source") as! String
        self.score = aDecoder.decodeInteger(forKey: "score")
        self.md5 = aDecoder.decodeObject(forKey: "md5") as! String
        self.fileSize = aDecoder.decodeInteger(forKey: "fileSize")
        self.fileUrl = aDecoder.decodeObject(forKey: "fileUrl") as! String
        self.isShownInIndex = aDecoder.decodeBool(forKey: "isShownInIndex")
        self.previewUrl = aDecoder.decodeObject(forKey: "previewUrl") as! String
        self.previewWidth = aDecoder.decodeInteger(forKey: "previewWidth")
        self.previewHeight = aDecoder.decodeInteger(forKey: "previewHeight")
        self.actualPreviewWidth = aDecoder.decodeInteger(forKey: "actualPreviewWidth")
        self.actualPreviewHeight = aDecoder.decodeInteger(forKey: "actualPreviewHeight")
        self.sampleUrl = aDecoder.decodeObject(forKey: "sampleUrl") as! String
        self.sampleWidth = aDecoder.decodeInteger(forKey: "sampleWidth")
        self.sampleHeight = aDecoder.decodeInteger(forKey: "sampleHeight")
        self.sampleFileSize = aDecoder.decodeInteger(forKey: "sampleFileSize")
        self.jpegUrl = aDecoder.decodeObject(forKey: "jpegUrl") as! String
        self.jpegWidth = aDecoder.decodeInteger(forKey: "jpegWidth")
        self.jpegHeight = aDecoder.decodeInteger(forKey: "jpegHeight")
        self.jpegFileSize = aDecoder.decodeInteger(forKey: "jpegFileSize")
        self.rating = aDecoder.decodeObject(forKey: "rating") as! String
        self.hasChildren = aDecoder.decodeBool(forKey: "hasChildren")
        if aDecoder.containsValue(forKey: "parentId") {
            self.parentId = aDecoder.decodeObject(forKey: "parentId") as? Int
        }
        self.status = aDecoder.decodeObject(forKey: "status") as! String
        self.width = aDecoder.decodeInteger(forKey: "width")
        self.height = aDecoder.decodeInteger(forKey: "height")
        self.isHeld = aDecoder.decodeBool(forKey: "isHeld")
        if aDecoder.containsValue(forKey: "flagDetail") {
            self.flagDetail = aDecoder.decodeObject(forKey: "flagDetail") as? String
        }
    }
    
    func getPreviewURL() -> URL {
        var urlComponent = URLComponents(string: previewUrl)!
        if urlComponent.scheme == nil {
            urlComponent.scheme = "https"
        }
        return urlComponent.url(relativeTo: nil)!
    }
    
    func getSampleURL() -> URL {
        var urlComponent = URLComponents(string: sampleUrl)!
        if urlComponent.scheme == nil {
            urlComponent.scheme = "https"
        }
        return urlComponent.url(relativeTo: nil)!
    }
    
    func getJpegURL() -> URL {
        var urlComponent = URLComponents(string: jpegUrl)!
        if urlComponent.scheme == nil {
            urlComponent.scheme = "https"
        }
        return urlComponent.url(relativeTo: nil)!
    }
    
    func getFileURL() -> URL {
        var urlComponent = URLComponents(string: fileUrl)!
        if urlComponent.scheme == nil {
            urlComponent.scheme = "https"
        }
        return urlComponent.url(relativeTo: nil)!
    }
}
