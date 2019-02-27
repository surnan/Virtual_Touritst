//
//  MapController+Gestures.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension MapController {
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state != .began {return}
        if sender.state != .ended {
            let touchLocation = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
            placeAnnotation(location: locationCoordinate)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            return
        }
    }
    
    func toggleBottomUILabel(show: Bool){
        show ? showBottomlabel() : hideBottomlabel()
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    func resetConstraintsOnBottomLabel(){
        mapViewTopAnchor_safeTop?.isActive = false
        mapViewTopAnchor_safeTop_EXTRA?.isActive = false
        mapViewBottomAnchor_viewBottom?.isActive = false
        mapViewBottomAnchor_viewBottom_EXTRA?.isActive = false
    }
    
    func hideBottomlabel(){
        resetConstraintsOnBottomLabel()
        mapViewTopAnchor_safeTop?.isActive = true
        mapViewBottomAnchor_viewBottom?.isActive = true
    }
    
    func showBottomlabel(){
        resetConstraintsOnBottomLabel()
        mapViewTopAnchor_safeTop_EXTRA?.isActive = true
        mapViewBottomAnchor_viewBottom_EXTRA?.isActive = true
    }
}
