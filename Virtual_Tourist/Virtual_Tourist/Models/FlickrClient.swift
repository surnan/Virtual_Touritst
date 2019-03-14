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
        case photosSearch(Double, Double, Int, Int32)   //Int32 because it's from core data and no need to convert types
        case getOnePicture(String , String)
        case getPhotosGetSizes(String)
        case photoDownloadURL()
        
        var toString: String {
            switch self {
            case .photosSearch(let latitude, let longitude, let maxPull, let page): return Endpoints.base
                + "method=flickr.photos.search"
                + "&api_key=\(API_KEY)"
                + "&lat=\(latitude)"
                + "&lon=\(longitude)"
                + "&per_page=\(maxPull)"
                + "&page=\(page)"
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
            case .photoDownloadURL(): return ""
            }
        }
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    
    
    class func searchNearbyPhotoData(currentPin: Pin, fetchCount count: Int, completion: @escaping ([URL], Error?)->Void)-> URLSessionTask{
        let latitude = currentPin.latitude
        let longitude = currentPin.longitude
        let pageNumber = currentPin.pageNumber
        
        
        let url = Endpoints.photosSearch(latitude, longitude, count, pageNumber).url
        //        print("Endpoints Photo-Search-URL = \(url)")
        
        var array_photo_URLs = [URL]()
        var array_photoID_secret = [[String: String]]()
        var array_URLString = [String]()
        var array_URLString2 = [String]()
        var count = 0
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            ////
            guard let dataObject = data, error == nil else {
                DispatchQueue.main.async {
                      completion([], error)
                }
                return
            } ////
            
            do {
                let temp = try JSONDecoder().decode(PhotosSearch.self, from: dataObject)
                temp.photos.photo.forEach{
                    let tempDict = [$0.id : $0.secret]
                    array_photoID_secret.append(tempDict)
                    
                    let photoURL = FlickrClient.Endpoints.getOnePicture($0.id, $0.secret)
                    let photoURLString = photoURL.toString
                    array_URLString.append(photoURLString)
        
                    
                    getPhotoURL(photoID: $0.id, secret: $0.secret, completion: { (urlString, error) in
                        guard let urlString = urlString else {return}
                        array_URLString2.append(urlString)
                        array_photo_URLs.append(URL(string: urlString)!)
                        
                        print("1 - array_URLString2 --> \(array_URLString2)")
                        count = count + 1
                        print("count --> \(count)")
                        print("temp.photos.photo.count --> \(temp.photos.photo.count)")
                        
                        if count == temp.photos.photo.count {
                            completion(array_photo_URLs, nil)
                        }
                        
                    })
                    print("2 - array_URLString2 --> \(array_URLString2)")
                }
                print("3 - array_URLString2 --> \(array_URLString2)")
            } catch let conversionErr {
                DispatchQueue.main.async {
                       completion([], conversionErr)
                }
                return
            }
        }
        print("4 - array_URLString2 --> \(array_URLString2)")
        task.resume()
        print("5 - array_URLString2 --> \(array_URLString2)")
        return task
    }
    
    
    
    

    class func getPhotoURL(photoID: String, secret: String, completion: @escaping (String?, Error?)->Void){
        let url = Endpoints.getOnePicture(photoID, secret).url
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataObject = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let temp = try JSONDecoder().decode(PhotosGetInfo.self, from: dataObject)
                DispatchQueue.main.async {
                    let urlString = "https://farm\(temp.photo.farm).staticflickr.com/\(temp.photo.server)/\(temp.photo.id)_\(temp.photo.secret)_m.jpg"
                    completion(urlString, nil)
                }
                return
            } catch let conversionErr {
                DispatchQueue.main.async {
                    completion(nil, conversionErr)
                }
                return   
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////
    
    class func searchNearbyURLMetaData(latitude: Double, longitude: Double, count: Int, pageNumber: Int32, completion: @escaping ([[String: String]], Error?)->Void )->URLSessionTask{
        let url = Endpoints.photosSearch(latitude, longitude, count, pageNumber).url
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
                DispatchQueue.main.async {
                    completion([[:]], conversionErr)
                }
                return
            }
        }
        task.resume()
        return task
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
                let dataObject = try JSONDecoder().decode(PhotosGetSizes.self, from: data)
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
}
