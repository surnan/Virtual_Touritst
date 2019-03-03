//
//  Cell.swift
//  Virtual_Tourist
//
//  Created by admin on 3/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class CollectionCell: UICollectionViewCell {
    
    var flickrImage: UIImage?{
        didSet{
            guard let tempImage = flickrImage else {return}
            cellImageView.image = tempImage
        }
    }
    
    var cellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "VirtualTourist_180")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
}
