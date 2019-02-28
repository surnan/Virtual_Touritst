//
//  GetBulkPhotoResponse.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation



struct APhotoStruct: Codable {
    var id: Double
    var owner: Double
    var secret: Double
    var server: Double
    var farm: Int
    var title: String
    var isPublic: Int
    var isfriend: Int
    var isfamily: Int
}

struct PhotosStruct: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photo: [APhotoStruct]
}


struct GetBulkPhotosResponse: Codable  {
    var photos: PhotosStruct
    var stat: String
}
