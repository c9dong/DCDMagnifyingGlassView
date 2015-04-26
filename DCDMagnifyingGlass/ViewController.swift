//
//  ViewController.swift
//  DCDMagnifyingGlass
//
//  Created by David Dong on 2015-04-01.
//  Copyright (c) 2015 David Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var magnifyingView: DCDMagnifyingGlassView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        var image = UIImage(named: "background")
        var imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(imageView)
        
        var testLabel = UILabel(frame: CGRectMake(100, 100, 100, 50))
        testLabel.text = "This is a test Label"
        self.view.addSubview(testLabel)
        
        var showButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        showButton.setTitle("show", forState: UIControlState.Normal)
        showButton.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
        showButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        self.view.addSubview(showButton)
        
        var draggingButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        draggingButton.setTitle("Allow drag", forState: UIControlState.Normal)
        draggingButton.addTarget(self, action: "dragAction:", forControlEvents: UIControlEvents.TouchUpInside)
        draggingButton.frame = CGRect(x: 120, y: 20, width: 100, height: 50)
        self.view.addSubview(draggingButton)
        
        DCDMagnifyingGlassView.setTargetView(self.view)
        DCDMagnifyingGlassView.setScale(5)
    }
    
    func showAction(sender: UIButton) {
        DCDMagnifyingGlassView.show(CGRect(x: 125,y: 100,width: 50,height: 50))
        sender.setTitle("hide", forState: UIControlState.Normal)
        sender.addTarget(self, action: "hideAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func hideAction(sender: UIButton) {
        DCDMagnifyingGlassView.dismiss()
        sender.setTitle("show", forState: UIControlState.Normal)
        sender.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func dragAction(sender: UIButton) {
        DCDMagnifyingGlassView.allowDragging(true)
        sender.setTitle("Disable drag", forState: UIControlState.Normal)
        sender.addTarget(self, action: "undragAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func undragAction(sender: UIButton) {
        DCDMagnifyingGlassView.allowDragging(false)
        sender.setTitle("Allow drag", forState: UIControlState.Normal)
        sender.addTarget(self, action: "dragAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}

