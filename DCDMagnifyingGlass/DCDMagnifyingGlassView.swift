//
//  DCDMagnifyingGlassView.swift
//  DCDMagnifyingGlass
//
//  Created by David Dong on 2015-04-01.
//  Copyright (c) 2015 David Dong. All rights reserved.
//

import Foundation
import UIKit

private let _DCDMagnifyingGlassViewInstance: DCDMagnifyingGlassView = DCDMagnifyingGlassView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

class DCDMagnifyingGlassView: UIView {
    
    //MARK: Singleton variable
    class var sharedInstance: DCDMagnifyingGlassView {
        return _DCDMagnifyingGlassViewInstance
    }
    
    //MARK: Properties
    let glassView: UIView = UIView()
    let magnifyingImageView: UIImageView = UIImageView()
    let indicatorView: UIView = UIView()
    let shadowLayer: CAShapeLayer = CAShapeLayer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    var targetView: UIView = UIApplication.sharedApplication().windows.first as! UIView
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
        //Set up the indicator
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/scale, height: self.frame.size.height/scale)
        indicatorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        indicatorView.layer.borderWidth = 2
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width/2
        indicatorView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(indicatorView)
        
        //Set up the glass
        var glassY = indicatorView.frame.origin.y - 10 - self.frame.size.height
        glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(glassView)
        
        //Add shadow layer
        shadowLayer.shadowColor = UIColor.blackColor().CGColor
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        glassView.layer.addSublayer(shadowLayer)
        
        //Set up the image display
        magnifyingImageView.frame = CGRect(x: 0, y: 0, width: glassView.frame.size.width, height: glassView.frame.size.height)
        magnifyingImageView.contentMode = UIViewContentMode.ScaleToFill
        magnifyingImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        magnifyingImageView.clipsToBounds = true
        glassView.addSubview(magnifyingImageView)
        
        //Set up gesture recognizer
        panGestureRecognizer.addTarget(self, action: "panAction:")
        indicatorView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.enabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutSubviews(false)
    }
    
    func layoutSubviews(animated: Bool) {
        let cornerRadius: CGFloat = CGFloat(max(frame.size.width, frame.size.height)/2)
        magnifyingImageView.layer.borderColor = UIColor.grayColor().CGColor
        magnifyingImageView.layer.cornerRadius = CGFloat(cornerRadius)
        
        //Update the indicator frame
        var indicatorSize = max(min(self.frame.size.width/scale, 50),10)
        indicatorView.frame = CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize)
        indicatorView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width/2
        
        //Update the frame of the glass
        if(panGestureRecognizer.enabled) {
            var glassY = indicatorView.frame.origin.y - 10 - self.frame.size.height
            if(animated) {
                UIView.animateWithDuration(0.25,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { () -> Void in
                        self.glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
                        self.indicatorView.alpha = 1
                    }, completion: nil)
            }else {
                glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
                self.indicatorView.alpha = 1
            }
            refreshImage()
        }else {
            if(animated) {
                UIView.animateWithDuration(0.25,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { () -> Void in
                        self.glassView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
                        self.indicatorView.alpha = 0
                    }, completion: nil)
            }else {
                glassView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
                self.indicatorView.alpha = 0
            }
        }
        refreshImage()
        
        //Update the shadow of the view
        let shadowPath = UIBezierPath(roundedRect: magnifyingImageView.frame, cornerRadius: cornerRadius)
        shadowLayer.shadowPath = shadowPath.CGPath
    }
    
    //MARK: Helper functions
    private func moveView(translation: CGPoint) {
        self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height)
        self.layoutSubviews(false)
    }
    
    private func snapshotTargetView(view: UIView!, inRect rect: CGRect!) -> UIImage! {
        //Hide self
        self.hidden = true
        
        var scale = UIScreen.mainScreen().scale
        
        //Snapshot of view
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -rect.origin.x, -rect.origin.y)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()) //Need this to stop screen flashing, but it's slower
        var snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show self
        self.hidden = false
        
        return snapshotImage
    }
    
    private func resizeImage(image: UIImage, toNewSize newSize:CGSize) -> UIImage {
        var scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //MARK: Refresh
    func refreshImage() {
        //Since we are scaling the image, we can take a snapshot of a smaller image instead, thus increasing performance
        var newWidth = self.frame.size.width / scale
        var newHeight = self.frame.size.height / scale
        var newX = (self.frame.size.width - newWidth) / 2 + self.frame.origin.x
        var newY = (self.frame.size.height - newHeight) / 2 + self.frame.origin.y
        var newImage = snapshotTargetView(targetView, inRect: CGRect(x: newX, y: newY, width: newWidth, height: newHeight))
        newImage = resizeImage(newImage, toNewSize: self.frame.size)
        magnifyingImageView.image = newImage
    }
    
    //MARK: Gesture Actions
    func panAction(sender: UIPanGestureRecognizer) {
        switch (sender.state){
        case UIGestureRecognizerState.Began:
            break
        case UIGestureRecognizerState.Changed:
            var translation = sender.translationInView(targetView)
            moveView(translation)
            sender.setTranslation(CGPointZero, inView: targetView)
            break
        case UIGestureRecognizerState.Ended, UIGestureRecognizerState.Failed:
            sender.setTranslation(CGPointZero, inView: targetView)
            break
        default:
            break
        }
    }
    
    //MARK: Hit Test
    func distanceFromPoint(point1: CGPoint, toPoint point2: CGPoint) -> CGFloat {
        var dx = point1.x - point2.x
        var dy = point1.y - point2.y
        
        return sqrt(dx*dx + dy*dy)
    }
    //Convert touch space into a circle instead of a rectangle
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
    
    class func allowDragging(allowDragging: Bool, animated: Bool) {
        DCDMagnifyingGlassView.sharedInstance.panGestureRecognizer.enabled = allowDragging
        DCDMagnifyingGlassView.sharedInstance.layoutSubviews(animated)
    }
    class func setContentFrame(frame: CGRect) {
        var correctedFrame = frame
        var width = frame.size.width
        var height = frame.size.height
        if(width != height) {
            width = min(width, height)
            height = width
            correctedFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
        }
        DCDMagnifyingGlassView.sharedInstance.frame = correctedFrame
    }
    class func setIndicatorColor(color: UIColor) {
        DCDMagnifyingGlassView.sharedInstance.indicatorView.layer.borderColor = color.CGColor
    }
    class func setShadowColor(color: UIColor) {
        DCDMagnifyingGlassView.sharedInstance.shadowLayer.shadowColor = color.CGColor
    }

    //MARK: Show/Dismiss
    class func show(animated: Bool) {
        DCDMagnifyingGlassView.sharedInstance.layoutSubviews(false)
        DCDMagnifyingGlassView.sharedInstance.targetView.addSubview(DCDMagnifyingGlassView.sharedInstance)
        if(animated) {
            DCDMagnifyingGlassView.sharedInstance.alpha = 0
            UIView.animateWithDuration(0.25,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    DCDMagnifyingGlassView.sharedInstance.alpha = 1
            }, completion: nil)
        }
    }
    
    class func dismiss(animated: Bool) {
        UIView.animateWithDuration(0.25,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                DCDMagnifyingGlassView.sharedInstance.alpha = 0
        }) { (completed) -> Void in
            DCDMagnifyingGlassView.sharedInstance.removeFromSuperview()
        }
    }
}