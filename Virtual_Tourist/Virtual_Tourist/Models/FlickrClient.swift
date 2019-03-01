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
        case photosSearch(Double, Double, Int)
        case getOnePicture(Double , String)
        
        var toString: String {
            switch self {
            case .photosSearch(let latitude, let longitude, let maxPull): return Endpoints.base
                + "method=flickr.photos.search"
                + "&api_key=\(API_KEY)"
                + "&lat=\(latitude)"
                + "&lon=\(longitude)"
                + "&per_page=\(maxPull)"
                + "&format=json"
                + "&nojsoncallback=1"
            case .getOnePicture(let photoID, let secret): return Endpoints.base
                + "method=flickr.photos.getInfo"
                + "&api_key=\(API_KEY)"
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
        let url = Endpoints.photosSearch(latitude, longitude, count).url
        print("getBulk")
        print(url)
    }
    
    class func getOnePicture(photoID: Double, secret: String){
        let url = Endpoints.getOnePicture(photoID, secret).url
        print("getOne")
        print(url)
    }
    
    
    class func SHOW_PHOTOS_GET_INFO(){
        //flickr.photos.getInfo
        
        let url2 = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=f5963392b48503b5e16b85a3cb31cf31&photo_id=33227389628.0&secret=28f5070254&format=json&nojsoncallback=1")!
        
        let session = URLSession.shared
        let task = session.dataTask(with: url2) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            //    print(String(data: data!, encoding: .utf8)!)
            
            
            guard let dataObject = data else {return}
            
            do {
                let temp = try JSONDecoder().decode(GetOnePicture.self, from: dataObject)
                //        print(temp.results)
                
                print("location = \(String(describing: temp.photo.urls.url.first?._content))")
                
            } catch let conversionErr {
                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
            }
        }
        task.resume()
    }
    
    
    
    class func SHOW_PHOTOS_SEARCH(){
        //flickr.photos.search
        
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f5963392b48503b5e16b85a3cb31cf31&lat=43.24242550936526&lon=-94.56005970000001&per_page=5&format=json&nojsoncallback=1")!
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            //    print(String(data: data!, encoding: .utf8)!)
            
            
            guard let dataObject = data else {return}
            
            do {
                let temp = try JSONDecoder().decode(GetBulkPhotosResponse.self, from: dataObject)
                
                temp.photos.photo.forEach{
                    print("id = \($0.id)  ..... secret = \($0.secret)")
                }
                
            } catch let conversionErr {
                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
            }
        }
        task.resume()
    }
}

