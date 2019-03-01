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
    
    private enum Endpoints {
        static let base = "https://api.flickr.com/services/rest/?"
        case photosSearch(Double, Double, Int)
        case getOnePicture(String , String)
        
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
    
    
    class func searchPhotos(latitude: Double, longitude: Double, count: Int, completion: @escaping ([[String: String]], Error?)->Void ){
        let url = Endpoints.photosSearch(latitude, longitude, count).url
        print(url)
        
        var answer = [[String: String]]()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataObject = data, error == nil else {
                completion([[:]], error)
                return
            }
            
            do {
                let temp = try JSONDecoder().decode(PhotosSearch.self, from: dataObject)
                temp.photos.photo.forEach{
                    let tempDict = [$0.id : $0.secret]
                    answer.append(tempDict)
                }
                completion(answer, nil)
                return
            } catch let conversionErr {
                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
                completion([[:]], error)
                return
            }
        }
        task.resume()
    }
    
    
    class func getPhotoURL(photoID: String, secret: String, completion: @escaping ([String])->Void){
        //flickr.photos.getInfo
        
        let url = Endpoints.getOnePicture(photoID, secret).url
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
    
            guard let dataObject = data, error == nil else {
                completion([])
                return
            }

            do {
                let temp = try JSONDecoder().decode(PhotosGetInfo.self, from: dataObject)
                //        print(temp.results)
                print("location = \(String(describing: temp.photo.urls.url.first?._content))")
            } catch let conversionErr {
                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
            }
        }
        task.resume()
    }
    
    
    //    class func SHOW_PHOTOS_SEARCH(){
    //        //flickr.photos.search
    //        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f5963392b48503b5e16b85a3cb31cf31&lat=43.24242550936526&lon=-94.56005970000001&per_page=5&format=json&nojsoncallback=1")!
    //        let session = URLSession.shared
    //        let task = session.dataTask(with: url) { data, response, error in
    //            if error != nil { // Handle error...
    //                return
    //            }
    //            guard let dataObject = data else {return}
    //            do {
    //                let temp = try JSONDecoder().decode(PhotosSearch.self, from: dataObject)
    //                temp.photos.photo.forEach{
    //                    print("id = \($0.id)  ..... secret = \($0.secret)")
    //                }
    //            } catch let conversionErr {
    //                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
    //            }
    //        }
    //        task.resume()
    //    }
}

