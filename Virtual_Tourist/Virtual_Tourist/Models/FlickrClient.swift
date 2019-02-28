//
//  FlickrClient.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//
//https://api.flickr.com/services

import Foundation

class FlickrClient {
    var endPoint = "https://api.flickr.com/services/"
    var restEndpointURL = "https://api.flickr.com/services/rest/"
    
    private enum Endpoints {
        static let base = "https://api.flickr.com/services/rest/?"
        case getBulkPhotos(Double, Double, Int)
        case getOnePicture(Double , String)

        var toString: String {
            switch self {
            case .getBulkPhotos(let latitude, let longitude, let maxPull): return Endpoints.base
                + "method=flickr.photos.search"
                + "&api_key=\(API_KEY)"
                + "&lat=\(latitude)"
                + "&lon=\(longitude)"
                + "&per_page=\(maxPull)"
                + "&format=json"
                + "&nojsoncallback=1"
            case .getOnePicture(let photoID, let secret): return Endpoints.base
                + "method=flickr.photos.getInfo"
                + "&api_key=54a938c45dc39b68d5c5daa806c2b830"
                + "&photo_id=\(photoID)"
                + "&secret=\(secret)"
                + "&format=json"
                + "&nojsoncallback=1"
            }
        }
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    
    class func getBulkPictures(latitude: Double, longitude: Double, count: Int){
        let url = Endpoints.getBulkPhotos(latitude, longitude, count).url
        print("getBulk")
        print(url)
    }
    
    class func getOnePicture(photoID: Double, secret: String){
        let url = Endpoints.getOnePicture(photoID, secret).url
        print("getOne")
        print(url)
    }
}
