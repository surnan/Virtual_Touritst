//
//  MapController+Gestures.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension MapController {
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state != .began || deletePhase {return}
        
        if sender.state != .ended {
            let touchLocation = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
            
            let pinToAdd = Pin(context: dataController.viewContext)
            pinToAdd.latitude = locationCoordinate.latitude
            pinToAdd.longitude = locationCoordinate.longitude
            
            try? dataController.viewContext.save()
            
            //            let touchLocation = sender.location(in: self.mapView)
            //            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
            //            placeAnnotation(location: locationCoordinate)
            // print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            return
        }
    }
    
    func toggleBottomUILabel(show: Bool){
        show ? showBottomlabel() : hideBottomlabel()
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    private func resetConstraintsOnBottomLabel(){
        mapViewTopAnchor_safeTop?.isActive = false
        mapViewTopAnchor_safeTop_EXTRA?.isActive = false
        mapViewBottomAnchor_viewBottom?.isActive = false
        mapViewBottomAnchor_viewBottom_EXTRA?.isActive = false
    }
    
    func hideBottomlabel(){ //ViewDidLoad
        resetConstraintsOnBottomLabel()
        mapViewTopAnchor_safeTop?.isActive = true
        mapViewBottomAnchor_viewBottom?.isActive = true
        deletePhase = false
    }
    
    private func showBottomlabel(){
        resetConstraintsOnBottomLabel()
        mapViewTopAnchor_safeTop_EXTRA?.isActive = true
        mapViewBottomAnchor_viewBottom_EXTRA?.isActive = true
        deletePhase = true
    }
}
