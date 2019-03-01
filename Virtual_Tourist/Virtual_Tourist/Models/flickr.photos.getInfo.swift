//
//  getOnePictureResponse.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//flickr.photos.getInfo


struct URLStruct: Codable {
    var type: String
    var _content: String
}

struct URLSStruct: Codable {
    var url: [URLStruct]
}

struct LocationStruct: Codable {
    var latitude: String
    var longitude: String
    var accuracy: String
    var context: String
    var county: [String: String]
    var region: [String: String]
    var country: [String: String]
    var place_id: String
    var woeid: String
}

struct TagStruct: Codable {
    var id: String
    var author: String
    var raw: String
    var _content: String
    var machine_tag: Double
}

struct OwnerStruct: Codable {
    var nsid: String
    var username: String
    var realname: String
    var location: String
    var iconserver: String
    var iconfarm: Double
    var path_alias: String?
}


struct PhotoStruct: Codable {
    var id: String
    var secret: String
    var server: String
    var farm: Double
    var dateuploaded: String
    var isfavorite: Double
    var license: String
    var safety_level: String
    var rotation: Double
    var originalsecret: String
    var originalformat: String
    var views: String
    var media: String
    var owner: OwnerStruct
    var title: [String:String]
    var description: [String: String]
    var visibility: [String: Double]
    var dates: [String: String]
    var editability: [String: Double]
    var publiceditability: [String: Double]
    var usage: [String: Double]
    var comments: [String: String]
    var notes: [String: [String]]
    var people: [String: Double]
    var tags: [String: [TagStruct]]
    var location: LocationStruct
    var geoperms: [String: Double]
    var urls: URLSStruct
}


struct GetOnePicture: Codable {
    var photo: PhotoStruct
    var stat: String
}


//let url2 = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=f5963392b48503b5e16b85a3cb31cf31&photo_id=33227389628.0&secret=28f5070254&format=json&nojsoncallback=1")!



//let session = URLSession.shared
//let task = session.dataTask(with: url2) { data, response, error in
//    if error != nil { // Handle error...
//        return
//    }
//
//    //    print(String(data: data!, encoding: .utf8)!)
//
//
//    guard let dataObject = data else {return}
//
//    do {
//        let temp = try JSONDecoder().decode(GetOnePicture.self, from: dataObject)
//        //        print(temp.results)
//
//        print("location = \(temp.photo.urls.url.first?._content)")
//
//    } catch let conversionErr {
//        print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
//    }
//}
//task.resume()

