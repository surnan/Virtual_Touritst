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
        case getPhotosGetSizes(String)
        
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
            case .getPhotosGetSizes(let photo_id): return Endpoints.base
                + "method=flickr.photos.getSizes"
                + "&api_key=\(API_KEY)"
                + "&photo_id=\(photo_id)"
                + "&format=json"
                + "&nojsoncallback=1"
            }
        }
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    
    class func getPhotoSizeWithURL(photoId: String, completion: @escaping (URL?, Error?)-> Void){
        let url = Endpoints.getPhotosGetSizes(photoId).url

        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            print("\n\n\nGoing to URLSession with --> \(url)")
            if let error = err {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, err)
                }
                return
            }
            
            do {
                let dataObject = try JSONDecoder().decode(Root.self, from: data)
                let temp = dataObject.sizes.size.last?.url
//                print(dataObject.sizes.size.last?.url)
                DispatchQueue.main.async {
                    completion(temp, nil)
                }
                return
            } catch let conversionErr {
                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
                DispatchQueue.main.async {
                    completion(nil, conversionErr)
                }
                return
            }
        }
        task.resume()
    }
    
    
    
    class func searchPhotos(latitude: Double, longitude: Double, count: Int, completion: @escaping ([[String: String]], Error?)->Void ){
        let url = Endpoints.photosSearch(latitude, longitude, count).url
        print("Endpoints Photo-Search-URL = \(url)")
        
        var answer = [[String: String]]()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataObject = data, error == nil else {
                DispatchQueue.main.async {
                    completion([[:]], error)
                }
                return
            }
            
            do {
                let temp = try JSONDecoder().decode(PhotosSearch.self, from: dataObject)
                temp.photos.photo.forEach{
                    let tempDict = [$0.id : $0.secret]
                    answer.append(tempDict)
                }
                DispatchQueue.main.async {
                    completion(answer, nil)
                }
                return
            } catch let conversionErr {
                print("\(conversionErr.localizedDescription)\n\n\(conversionErr)")
                DispatchQueue.main.async {
                    completion([[:]], conversionErr)
                }
                return
            }
        }
        task.resume()
    }
    
    
    class func getPhotoURL(photoID: String, secret: String, completion: @escaping (URL?, Error?)->Void){
        //flickr.photos.getInfo
        let url = Endpoints.getOnePicture(photoID, secret).url
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //            print("Endpoints Get-Photo-URL = \(url)")
            guard let dataObject = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let temp = try JSONDecoder().decode(PhotosGetInfo.self, from: dataObject)
//                if let returnURL = URL(string: (temp.photo.urls.url.first?._content) ?? "") {
                
                
                 if let returnURL = temp.photo.urls.url.first?._content {
                    DispatchQueue.main.async {
                        completion(returnURL, nil)
                    }
                    return
                }
            } catch let conversionErr {
                print("\(url) --> ERROR --> \n\(conversionErr)")
                DispatchQueue.main.async {
                    completion(nil, conversionErr)
                }
                return   
            }
        }
        task.resume()
    }
}
