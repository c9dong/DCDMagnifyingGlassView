//
//  UIImage+Snapshot.swift
//  DCDMagnifyingGlass
//
//  Created by David Dong on 2015-04-03.
//  Copyright (c) 2015 David Dong. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //Take a snapshot of a section of a view
    class func imageBySnapshotView(view: UIView!, inRect rect: CGRect!, ExcludeViews excludedViews: Array<UIView>?) -> UIImage! {
        
        //Hide all excluded views
        if(excludedViews != nil){
            for _view in excludedViews!{
                _view.hidden = true;
            }
        }
        
        var scale = UIScreen.mainScreen().scale
        
        //Snapshot of view
        UIGraphicsBeginImageContextWithOptions(rect.size, true, scale)
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -rect.origin.x, -rect.origin.y)
        //newView.drawViewHierarchyInRect(newView.bounds, afterScreenUpdates: true)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()) //Need this to stop screen flashing, but it's slower
        var snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //Show all excluded views
        if(excludedViews != nil){
            for _view in excludedViews!{
                _view.hidden = false;
            }
        }
        
        return snapshotImage
    }
}