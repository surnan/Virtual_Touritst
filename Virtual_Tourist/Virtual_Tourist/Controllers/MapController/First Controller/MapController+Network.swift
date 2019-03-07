////
////  MapController+Network.swift
////  Virtual_Tourist
////
////  Created by admin on 3/6/19.
////  Copyright © 2019 admin. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreData
//
//extension MapController {
//    
//    func handleFlickrClientSearchPhotos(pictureList: [[String: String]], error: Error?){
//        if let err = error {
//            print("Error in Handler: \(err)")
//            return
//        }
//        pictureList.forEach { (temp) in
//            temp.forEach{
//                FlickrClient.getPhotoURL(photoID: $0.key, secret: $0.value, completion: handleFlickrClientGetPhotoURL(url:error:))
//            }
//        }
//    }
//    
//    
//    func handleFlickrClientGetPhotoURL(url: URL?, error: Error?){
//        print("hello world")
//        if let myURL = url {
//            downloadImageFromURL(myURL: myURL) {(data, error) in
//                if let myImage = data {
//                    imageArray.append(myImage)
//                    imageArray.append(myImage)
//                    print("BREAK HERE")
//                } else {
//                    print("Unable to get Photo from downloadImageFromURL")
//                }
//            }
//        } else {
//            print("Error inside closure from GETPHOTOURL: \(String(describing: error))")
//        }
//    }
//    
//    func downloadImageFromURL(myURL: URL, completion: @escaping (UIImage?, Error?)->Void){
//        URLSession.shared.dataTask(with: myURL) {(data, response, error) in
//            if let data = data, let tempImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    completion(tempImage, nil)
//                }
//                return
//            } else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            }.resume()
//    }
//    
//}
