//
//  Cell.swift
//  Virtual_Tourist
//
//  Created by admin on 3/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class CollectionCell2: UICollectionViewCell {
    
    var message: String?{
        didSet {
            myLabel.text = message
        }
    }
    
    var myLabel: UILabel = {
       let label = UILabel()
        label.text = "abcde"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        addSubview(myLabel)
        myLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
