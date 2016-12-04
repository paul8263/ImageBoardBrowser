//
//  ImageInfo.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation

class ImageInfo {
    var id: Int = 0
    var tags: String = ""
    var createdAt: Int = 0
    var creatorId: Int = 0
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
        self.creatorId = fromDict["creator_id"] as! Int
        self.author = fromDict["author"] as! String
        self.change = fromDict["change"] as! Int
        self.source = fromDict["source"] as! String
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
}
