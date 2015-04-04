//
//  UIImageView+Snapshot.swift
//  DCDMagnifyingGlass
//
//  Created by Negin Hodaie on 2015-04-03.
//  Copyright (c) 2015 Negin Hodaie. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    //TODO: fix up this shit
    //Magnify a section of a view and adds it to the view hierachy
    class func magnifiedView(view: UIView!, inRect rect: CGRect!, scale:CGFloat) -> UIView! {
        //Get cropped image
        var croppedImage = UIImage.imageBySnapshotView(view, inRect: rect, ExcludeViews: nil)
        
        //Add cropped image to view
        var croppedImageView = UIImageView(image: croppedImage)
        croppedImageView.frame = rect;
        croppedImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale)
        croppedImageView.layer.cornerRadius = max(rect.size.width, rect.size.height)/2
        croppedImageView.layer.shadowColor = UIColor.blackColor().CGColor
        croppedImageView.layer.shadowOpacity = 0.5
        view.addSubview(croppedImageView)
        
        return croppedImageView
    }
}