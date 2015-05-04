# DCDMagnifyingGlassView

Magnify your views anywhere, at anytime, using **`DCDMagnifyingGlassView`**!

Text                                        |Image
:------------------------------------------:|:------------------------------------------:
![DCDMagnifyingGlass Demo](https://github.com/c9dong/DCDMagnifyingGlassView/blob/master/Images/DCDMagnifyingGlassVideo1.gif)|![DCDMagnifyingGlass Demo] (https://github.com/c9dong/DCDMagnifyingGlassView/blob/master/Images/DCDMagnifyingGlassVideo2.gif)

## How to Use

You can configure **`DCDMagnifyingGlassView`** using the following class methods:

```objective-c
//The view to magnify, you must set this for the view to work
class func setTargetView(targetView: UIView)
//How much you want to magnify the view, default is 2x
class func setScale(scale: CGFloat)
 //Allow you to drag the view, default is false
class func allowDragging(allowDragging: Bool)
```

You can show and dismiss **`DCDMagnifyingGlassView`** using the following class methods:

```objective-c
//Set the frame of DCDMagnifyingGlassView and add it to the targetView
class func show(frame: CGRect) //No animation
class func show(frame: CGRect, animated: Bool)

//Dismiss DCDMagnifyingGlassView and remove it from the targetView
class func dismiss() //No animation
class func dismissAnimated(animated: Bool)
```

## Example Code Using Swift

```objective-c
override func viewDidLoad(){
  super.viewDidLoad()
  DCDMagnifyingGlassView.setTargetView(self.view)
  DCDMagnifyingGlassView.setScale(5.0)
  DCDMagnifyingGlassView.allowDragging(true)
  
  //Initialize views
  ...
}

func showButtonClicked(sender: UIButton){
  DCDMagnifyingGlassView.show(CGRect(x: 115,y: 90,width:  100,height: 100), animated: true)
}

func hideButtonClicked(sender: UIButton){
  DCDMagnifyingGlassView.dismissAnimated(true)
}
```

## Credit

**`DCDMagnifyingGlassView`** is brought to you by David Dong

