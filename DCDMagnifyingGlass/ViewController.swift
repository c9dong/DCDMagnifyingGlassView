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
        self.view.backgroundColor = UIColor.whiteColor()
        
        var label = UILabel(frame: CGRect(x: 12, y: 50, width: self.view.bounds.size.width-24, height: self.view.bounds.size.height-50))
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(20)
        label.text = "Public holidays in Thailand are regulated by the government, and most are observed by both the public and private sectors. There are usually sixteen public holidays in a year, but more may be declared by the Cabinet. The actual number of holidays for the individual is determined by the nature of the organization for which they work i.e. public, private, institutions governed by the Bank of Thailand, or state-owned enterprises (excluding financial institutions).[1] On average, workers in the first three groups are entitled to fourteen holidays, while state-owned enterprise workers enjoy up to fifteen holidays (or more). If a holiday falls on a weekend, one following workday is observed as a compensatory holiday.[1] The Bank of Thailand regulates bank holidays, which differ slightly from those observed by the government. Other observances, both official and non-official, local and international, are observed to varying degrees throughout the country."
        self.view.addSubview(label)
        
        var image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = UIViewContentMode.ScaleAspectFill
        image.frame = self.view.bounds 
        self.view.addSubview(image)
        
        var showButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        showButton.setTitle("show", forState: UIControlState.Normal)
        showButton.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
        showButton.sizeToFit()
        showButton.center = CGPoint(x: self.view.bounds.size.width/2, y: 200)
        self.view.addSubview(showButton)
        
        DCDMagnifyingGlassView.setTargetView(self.view)
        DCDMagnifyingGlassView.setScale(5.0)
    }
    
    func showAction(sender: UIButton) {
        DCDMagnifyingGlassView.show(CGRect(x: 115,y: 90,width:  100,height: 100), animated: true)
        sender.setTitle("hide", forState: UIControlState.Normal)
        sender.removeTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
        sender.addTarget(self, action: "hideAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func hideAction(sender: UIButton) {
        DCDMagnifyingGlassView.dismissAnimated(true)
        sender.setTitle("show", forState: UIControlState.Normal)
        sender.removeTarget(self, action: "hideAction:", forControlEvents: UIControlEvents.TouchUpInside)
        sender.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func dragAction(sender: UIButton) {
        DCDMagnifyingGlassView.allowDragging(true)
        sender.setTitle("Disable drag", forState: UIControlState.Normal)
        sender.removeTarget(self, action: "dragAction:", forControlEvents: UIControlEvents.TouchUpInside)
        sender.addTarget(self, action: "undragAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func undragAction(sender: UIButton) {
        DCDMagnifyingGlassView.allowDragging(false)
        sender.setTitle("Allow drag", forState: UIControlState.Normal)
        sender.removeTarget(self, action: "undragAction:", forControlEvents: UIControlEvents.TouchUpInside)
        sender.addTarget(self, action: "dragAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}

