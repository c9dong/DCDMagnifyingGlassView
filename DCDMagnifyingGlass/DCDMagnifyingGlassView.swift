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
    let magnifyingImageView: UIImageView = UIImageView()
    let shadowLayer: CAShapeLayer = CAShapeLayer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    var targetView: UIView?
    var scale: CGFloat = 2
    
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
        //Add shadow layer
        self.layer.addSublayer(shadowLayer)
        
        //Set up views
        magnifyingImageView.frame = self.bounds
        magnifyingImageView.contentMode = UIViewContentMode.ScaleToFill
        magnifyingImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        magnifyingImageView.clipsToBounds = true
        self.addSubview(magnifyingImageView)
        
        //Set up gesture recognizer
        panGestureRecognizer.addTarget(self, action: "panAction:")
        self.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.enabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius: CGFloat = CGFloat(max(frame.size.width, frame.size.height)/2)
        magnifyingImageView.layer.borderColor = UIColor.grayColor().CGColor
        magnifyingImageView.layer.cornerRadius = CGFloat(cornerRadius)
        
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        shadowLayer.shadowPath = shadowPath.CGPath
        shadowLayer.shadowColor = UIColor.blackColor().CGColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        
        if(targetView != nil){
            refreshImage()
        }
    }
    
    
    //MARK: Helper functions
    private func moveView(translation: CGPoint) {
        self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height)
        self.layoutSubviews()
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
    
    //MARK: Hit Test
    func distanceFromPoint(point1: CGPoint, toPoint point2: CGPoint) -> CGFloat {
        var dx = point1.x - point2.x
        var dy = point1.y - point2.y
        
        return sqrt(dx*dx + dy*dy)
    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var radius = self.bounds.size.width/2
        var center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        var dist = distanceFromPoint(point, toPoint: center)
        if(dist <= radius){
            return super.hitTest(point, withEvent: event)
        }
        
        return nil
    }
    
    //MARK: Set Properties
    class func setTargetView(targetView: UIView){
        DCDMagnifyingGlassView.sharedInstance.targetView = targetView
    }
    
    class func setScale(scale: CGFloat){
        DCDMagnifyingGlassView.sharedInstance.scale = scale
    }
    
    class func allowDragging(allowDragging: Bool) {
        DCDMagnifyingGlassView.sharedInstance.panGestureRecognizer.enabled = allowDragging
    }
    
    //MARK: Show/Dismiss
    class func show(frame: CGRect) {
        DCDMagnifyingGlassView.show(frame, animated: false)
    }
    
    class func show(frame: CGRect, animated: Bool) {
        if(DCDMagnifyingGlassView.sharedInstance.targetView == nil){
            return;
        }
        DCDMagnifyingGlassView.sharedInstance.frame = frame;
        DCDMagnifyingGlassView.sharedInstance.layoutSubviews()
        DCDMagnifyingGlassView.sharedInstance.targetView?.addSubview(DCDMagnifyingGlassView.sharedInstance)
        if(animated) {
            DCDMagnifyingGlassView.sharedInstance.alpha = 0
            UIView.animateWithDuration(0.25,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    DCDMagnifyingGlassView.sharedInstance.alpha = 1
            }, completion: nil);
        }
    }
    
    class func dismiss() {
        DCDMagnifyingGlassView.dismissAnimated(false)
    }
    
    class func dismissAnimated(animated: Bool) {
        if(DCDMagnifyingGlassView.sharedInstance.targetView == nil) {
            return;
        }
        UIView.animateWithDuration(0.25,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                DCDMagnifyingGlassView.sharedInstance.alpha = 0
        }) { (completed) -> Void in
            DCDMagnifyingGlassView.sharedInstance.removeFromSuperview()
        };
    }
}