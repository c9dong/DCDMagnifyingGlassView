//
//  DCDMagnifyingGlassView.swift
//  DCDMagnifyingGlass
//
//  Created by Negin Hodaie on 2015-04-01.
//  Copyright (c) 2015 Negin Hodaie. All rights reserved.
//

import Foundation
import UIKit

class DCDMagnifyingGlassView: UIView {
    var magnifyingImageView: UIImageView?
    var targetView: UIView? {
        didSet {
            print(magnifyingImageView?.frame)
            //self.magnifyingImageView?.image = DCDMagnifyingGlassView.snapshotView(self.targetView, inRect: self.frame)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Set up views
        magnifyingImageView = UIImageView(frame: frame)
        magnifyingImageView?.frame = self.bounds
        magnifyingImageView?.contentMode = UIViewContentMode.ScaleToFill
        print(magnifyingImageView?.frame)
        magnifyingImageView?.transform = CGAffineTransformScale(CGAffineTransformIdentity,5, 5)
        magnifyingImageView?.layer.cornerRadius = max(frame.size.width, frame.size.height)/2
        magnifyingImageView?.layer.shadowColor = UIColor.blackColor().CGColor
        magnifyingImageView?.layer.shadowOpacity = 0.5
        self.addSubview(magnifyingImageView!)
        
        //Set up gesture recognizer
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.addGestureRecognizer(panGestureRecognizer)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.magnifyingImageView?.image = DCDMagnifyingGlassView.snapshotView(self.targetView, inRect: self.frame)
        //self.magnifyingImageView? = DCDMagnifyingGlassView.magnifyView(targetView, inRect: self.frame, scale: 5) as UIImageView;
        //self.addSubview(magnifyingImageView!);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Take a snapshot of a section of a view
    class func snapshotView(view: UIView!, inRect rect: CGRect!) -> UIImage! {
        //Snapshot of whole view
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        var snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Crop image
        UIGraphicsBeginImageContext(rect.size)
        snapshotImage.drawAtPoint(CGPointMake(-rect.origin.x, -rect.origin.y))
        var cutImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return cutImage
    }
    
    //Magnify a section of a view and adds it to the view hierachy
    class func magnifyView(view: UIView!, inRect rect: CGRect!, scale:CGFloat) -> UIView! {
        //Get cropped image
        var croppedImage = snapshotView(view, inRect: rect)
        
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
    
    func setImage() {
        self.magnifyingImageView?.image = DCDMagnifyingGlassView.snapshotView(self.targetView, inRect: self.frame)
    }
    
    //MARK: Gesture Actions
    func panAction(sender: UIPanGestureRecognizer) {
        switch (sender.state){
        case UIGestureRecognizerState.Began:
            sender.setTranslation(CGPointZero, inView: targetView!)
            break;
        case UIGestureRecognizerState.Changed:
            //print(sender.translationInView(targetView!).x, sender.translationInView(targetView!).y)
            var translation = sender.translationInView(targetView!)
            moveView(translation)
            sender.setTranslation(CGPointZero, inView: targetView!)
            break;
        case UIGestureRecognizerState.Ended, UIGestureRecognizerState.Failed:
            sender.setTranslation(CGPointZero, inView: targetView!)
            break;
        default:
            break;
        }
    }
    
    private func moveView(translation: CGPoint) {
        self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height)
        //Set new image
        self.hidden = true
        var image = DCDMagnifyingGlassView.snapshotView(self.targetView, inRect: self.frame)
        self.magnifyingImageView?.image = image
        self.hidden = false
    }
}