//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    
    func setupNavigationBar(){
        let editBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditBarButton))
        
        navigationItem.rightBarButtonItem = editBarButton
        
        
    }
    
    
    @objc func handleEditBarButton(){
        navigationController?.pushViewController(ShowingPicsController(), animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        setupNavigationBar()
    }
}





extension MapController {
    
}
