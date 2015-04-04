//
//  UIImage+Resize.swift
//  DCDMagnifyingGlass
//
//  Created by Negin Hodaie on 2015-04-03.
//  Copyright (c) 2015 Negin Hodaie. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //Scale an image to new size
    class func imageByResizingImage(image: UIImage!, toNewSize newSize: CGSize!) -> UIImage!{
        var scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, scale)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage;
    }
}