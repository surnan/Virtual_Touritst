//
//  MyCollectionCell.swift
//  Loading Screen Test
//
//  Created by admin on 3/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CollectionCell2:UICollectionViewCell{
    
    let blueBackGround: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let myActivityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .whiteLarge
        activityView.startAnimating()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    let myView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myView)
        myView.insertSubview(myActivityIndicatorView, at: 0)
        myView.insertSubview(blueBackGround, at: 0)
        
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: topAnchor),
            myView.bottomAnchor.constraint(equalTo: bottomAnchor),
            myView.leadingAnchor.constraint(equalTo: leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: trailingAnchor),
            myActivityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            myActivityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            blueBackGround.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            blueBackGround.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            blueBackGround.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            blueBackGround.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myActivityIndicatorView.startAnimating()
    }
}
