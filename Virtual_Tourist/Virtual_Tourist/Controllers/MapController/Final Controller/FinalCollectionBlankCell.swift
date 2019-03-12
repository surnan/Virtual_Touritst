//
//  FinalCollectionBlankCell.swift
//  Virtual_Tourist
//
//  Created by admin on 3/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class FinalCollectionBlankCell: UICollectionViewCell {
    
    var myView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(myView)
        myView.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
