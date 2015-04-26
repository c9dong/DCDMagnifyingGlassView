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
        
        /*magnifyingView = DCDMagnifyingGlassView(frame: CGRectMake(40, 40, 100, 100))
        magnifyingView?.targetView = self.view
        magnifyingView?.scale = 2
        self.view.addSubview(magnifyingView!)*/
        
//        var magnifyingView2 = DCDMagnifyingGlassView(frame: CGRectMake(20, 20,50, 50))
//        magnifyingView2.targetView = magnifyingView
//        magnifyingView2.scale = 2
//        magnifyingView?.addSubview(magnifyingView2)
        
        var testLabel = UILabel(frame: CGRectMake(100, 100, 100, 50))
        testLabel.text = "This is a test Label"
        self.view.addSubview(testLabel)
        
        DCDMagnifyingGlassView.setTargetView(self.view)
        DCDMagnifyingGlassView.setScale(5)
        DCDMagnifyingGlassView.show(CGRect(x: 125,y: 100,width: 50,height: 50))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //var croppedImageView = DCDMagnifyingGlassView.magnifyView(self.view, inRect: CGRectMake(0, 300, 60, 60), scale: 3)
    }
}

