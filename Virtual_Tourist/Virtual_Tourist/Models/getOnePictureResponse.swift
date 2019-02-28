//
//  getOnePictureResponse.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct LocationStruct: Codable {
    var latitude: Double
    var longitude: Double
    var accuracy: Double
    var context: Double
    var county: [String:String]
    var region: [String: String]
    var country: [String:String]
    var place_id: String
    var woeid: String
}

struct PhotoStruct: Codable {
    var id: Double
    var secret: Double
    var server: Double
    var farm: String
    var dateuploaded: String
    var isfavorite: String
    var license: String
    var safety_level: String
    var rotation: String
    var originalsecret: String
    var originalformat: String
    var views: String
    var media: String
    
    var owner: [String: String]
    var title: [String:String]
    var description: [String:String]
    var visibility: [String: String]
    var dates: [String: String]
    var editability: [String: String]
    var publiceditability: [String: String]
    var usage: [String: String]
    var comments: [String: String]
    var notes: [String: [String]]
    var people: [String: String]
    var tags: [String: [String: String]]
    var location: LocationStruct
    var geoperms: [String: String]
    var url: [String: [String: String]]
}









struct GetOnePicture: Codable {
    var photo: PhotoStruct
    var stat: String
}
