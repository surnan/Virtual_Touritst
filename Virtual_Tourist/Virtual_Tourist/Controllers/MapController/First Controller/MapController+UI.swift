//
//  MapController+UI.swift
//  Virtual_Tourist
//
//  Created by admin on 3/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension MapController {
    private func setupNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: defaultTitleFontSize)]
        navigationItem.title = "Virtual Tourist"
        let editDoneButton: UIButton = {
            let button = UIButton()
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: defaultFontSize)]), for: .selected)
            button.setTitle("Done", for: .selected)
            button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
            button.isSelected = false
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        let customBarButton = UIBarButtonItem(customView: editDoneButton)
        self.navigationItem.setRightBarButton(customBarButton, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete ALL", style: .done, target: self, action: #selector(handleDeleteALLButton))
    }

    func setupUI(){
        setupNavigationBar()
        [mapView, bottomUILabel].forEach{view.addSubview($0)}
        mapView.anchor(top: nil, leading: bottomUILabel.leadingAnchor, trailing: bottomUILabel.trailingAnchor, bottom: nil)
        bottomUILabel.anchor(top: mapView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil)
        
        anchorMapTop_SafeAreaTop =  mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        anchorMapTop_ShiftMapToShowDeletionLabel = mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -bottomUILabelHeight)
        anchorMapBottom_ViewBottom =  mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        anchorMapBottom_ShiftMapToShowDeletionLabel = mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomUILabelHeight)
        hideBottomlabel()
    }
    
    private func resetConstraintsOnBottomLabel(){
        anchorMapTop_SafeAreaTop?.isActive = false
        anchorMapTop_ShiftMapToShowDeletionLabel?.isActive = false
        anchorMapBottom_ViewBottom?.isActive = false
        anchorMapBottom_ShiftMapToShowDeletionLabel?.isActive = false
    }
    
    func hideBottomlabel(){ //ViewDidLoad
        resetConstraintsOnBottomLabel()
        anchorMapTop_SafeAreaTop?.isActive = true
        anchorMapBottom_ViewBottom?.isActive = true
        tapDeletesPin = false
    }
    
    //Called by: func toggleBottomUILabel(show: Bool){..}
    func showBottomlabel(){
        resetConstraintsOnBottomLabel()
        anchorMapTop_ShiftMapToShowDeletionLabel?.isActive = true
        anchorMapBottom_ShiftMapToShowDeletionLabel?.isActive = true
        tapDeletesPin = true
    }
}

