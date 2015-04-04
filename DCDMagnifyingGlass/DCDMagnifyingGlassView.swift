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
    
    //MARK: Properties
    var scale: CGFloat = 2 {
        didSet {
            refreshImage()
        }
    }
    
    let magnifyingImageView: UIImageView?
    
    var targetView: UIView? {
        didSet {
            refreshImage()
        }
    }
    
    //MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Set up views
        magnifyingImageView = UIImageView(frame: frame)
        magnifyingImageView?.frame = self.bounds
        magnifyingImageView?.contentMode = UIViewContentMode.ScaleToFill
        print(magnifyingImageView?.frame)
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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: Helper functions
    private func moveView(translation: CGPoint) {
        self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height)
        //Set new image
        refreshImage()
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
        magnifyingImageView?.image = newImage
    }
    
    //MARK: Gesture Actions
    func panAction(sender: UIPanGestureRecognizer) {
        switch (sender.state){
        case UIGestureRecognizerState.Began:
            sender.setTranslation(CGPointZero, inView: targetView!)
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
}