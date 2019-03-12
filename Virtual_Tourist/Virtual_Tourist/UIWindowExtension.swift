//
//  UIWindowExtension.swift
//  checkActiveViewController
//
//  Created by admin on 3/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}

func getTopViewController() -> UIViewController? {
    let appDelegate = UIApplication.shared.delegate
    if let window = appDelegate!.window {
        return window?.visibleViewController
    }
    return nil
}

func showVC(){
    if let topVC = getTopViewController() {
        switch topVC {
        case is MapController:
            print("We are in side MapController")
        case is CollectionMapViewController:
            print("We are inside FinalCollectionView")
        default:
            print("where am i?")
        }
        
    }
}
