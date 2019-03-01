//
//  GetBulkPhotoResponse.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//flickr.photos.search

struct PhotosSearch: Codable  {
    var photos: PhotosStruct
    var stat: String
    
    struct PhotosStruct: Codable {
        var page: Double
        var pages: Double
        var perpage: Double
        var total: String
        var photo: [PhotoStruct]
    }
    
    struct PhotoStruct: Codable {
        var id: String
        var owner: String
        var secret: String
        var server: String
        var farm: Double
        var title: String
        var ispublic: Double
        var isfriend: Double
        var isfamily: Double
    }
}

//let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f5963392b48503b5e16b85a3cb31cf31&lat=43.24242550936526&lon=-94.56005970000001&per_page=5&format=json&nojsoncallback=1")!


//let session = URLSession.shared
//let task = session.dataTask(with: url) { data, response, error in
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
//        let temp = try JSONDecoder().decode(GetBulkPhotosResponse.self, from: dataObject)
//
//        temp.photos.photo.forEach{
//            print("id = \($0.id)  ..... secret = \($0.secret)")
//        }
//
//    } catch let conversionErr {
//        print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
//    }
//}
//task.resume()

