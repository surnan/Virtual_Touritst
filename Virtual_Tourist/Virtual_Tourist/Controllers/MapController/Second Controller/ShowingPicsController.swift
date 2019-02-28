//
//  ShowingPicsController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class ShowingPicsController: UIViewController {
    
    func showNavigationController(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(handleLeftBarButton))
    }
    
    
    @objc func handleLeftBarButton(){
        print("Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.red
        
        
        FlickrClient.getOnePicture(photoID: 33227389628, secret: "28f5070254")
        FlickrClient.getBulkPictures(latitude: 42.25381312064496, longitude: -98.89378365942025, count: 5)
        
        
    }
    
    
    
    
}
