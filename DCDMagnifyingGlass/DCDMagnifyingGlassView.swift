//
//  DCDMagnifyingGlassView.swift
//  DCDMagnifyingGlass
//
//  Created by David Dong on 2015-04-01.
//  Copyright (c) 2015 David Dong. All rights reserved.
//

import Foundation
import UIKit

private let _DCDMagnifyingGlassViewInstance = DCDMagnifyingGlassView()

class DCDMagnifyingGlassView: UIView {
    
    //MARK: Singleton variable
    class var sharedInstance: DCDMagnifyingGlassView {
        return _DCDMagnifyingGlassViewInstance
    }
    
    //MARK: Properties
    var scale: CGFloat = 2
    
    let magnifyingImageView: UIImageView = UIImageView()
    
    var targetView: UIView?
    
    //MARK: Constructors
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        //Set up views
        magnifyingImageView.frame = frame;
        magnifyingImageView.frame = self.bounds
        magnifyingImageView.contentMode = UIViewContentMode.ScaleToFill
        magnifyingImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(magnifyingImageView)
        
        //Set up gesture recognizer
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.addGestureRecognizer(panGestureRecognizer)
        
        //Config layer
        let cornerRadius: CGFloat = CGFloat(max(frame.size.width, frame.size.height)/2)
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).CGPath
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(targetView != nil){
            refreshImage()
        }
    }
    
    
    //MARK: Helper functions
    private func moveView(translation: CGPoint) {
        self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height)
    }
    
    //MARK: Refresh
    func refreshImage() {
        //Since we are scaling the image, we can take a snapshot of a smaller image instead, thus increasing performance
        var newWidth = self.frame.size.width / scale
        var newHeight = self.frame.size.height / scale
        var newX = (self.frame.size.width - newWidth) / 2 + self.frame.origin.x
        var newY = (self.frame.size.height - newHeight) / 2 + self.frame.origin.y
        var newImage = UIImage.imageBySnapshotView(targetView, inRect: CGRectMake(newX, newY, newWidth, newHeight), ExcludeViews: [self])
        newImage = UIImage.imageByResizingImage(newImage, toNewSize: self.frame.size)
        magnifyingImageView.image = newImage
    }
    
    //MARK: Gesture Actions
    func panAction(sender: UIPanGestureRecognizer) {
        switch (sender.state){
        case UIGestureRecognizerState.Began:
            break;
        case UIGestureRecognizerState.Changed:
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
    
    //MARK: Set properties
    class func setTargetView(targetView: UIView){
        DCDMagnifyingGlassView.sharedInstance.targetView = targetView
    }
    
    class func setScale(scale: CGFloat){
        DCDMagnifyingGlassView.sharedInstance.scale = scale
    }
    
    //MARK: Show/Dismiss
    class func show(frame: CGRect) {
        DCDMagnifyingGlassView.sharedInstance.frame = frame;
        
        if(DCDMagnifyingGlassView.sharedInstance.targetView != nil){
            DCDMagnifyingGlassView.sharedInstance.targetView?.addSubview(DCDMagnifyingGlassView.sharedInstance)
        }
    }
    
    class func dismiss() {
        DCDMagnifyingGlassView.sharedInstance.removeFromSuperview()
    }
}