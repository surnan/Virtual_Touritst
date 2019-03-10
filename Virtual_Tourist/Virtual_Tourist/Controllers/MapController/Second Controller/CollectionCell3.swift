//
//  CollectionCell3.swift
//  Virtual_Tourist
//
//  Created by admin on 3/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class CollectionCell3: UICollectionViewCell {
    
    var myPhoto: Photo! {
        didSet {
            if let myImageData = myPhoto.imageData, let myImage = UIImage(data: myImageData) {
                myImageView.image = myImage
            }
        }
    }
    
    var myImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
}



