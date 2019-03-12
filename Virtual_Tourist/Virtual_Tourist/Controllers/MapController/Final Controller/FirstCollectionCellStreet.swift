//
//  FirstCollectionCellStreet.swift
//  Loading Screen Test
//
//  Created by admin on 3/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class FirstCollectionCellStreet: UICollectionViewCell {
    var image = UIImage(){
        didSet{
            fullImageView.image = image
        }
    }

    var fullImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "home")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(fullImageView)
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: topAnchor),
            fullImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fullImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fullImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
