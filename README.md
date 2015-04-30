# DCDMagnifyingGlassView

Magnify your views anywhere, at anytime, using `DCDMagnifyingGlassView`!

## How to Use

You can configure `DCDMagnifyingGlassView` using the following class methods:

```objective-c
class func setTargetView(targetView: UIView) //The view to magnify, you must set this for the view to work
class func setScale(scale: CGFloat) //How much you want to magnify the view, default is 2x
class func allowDragging(allowDragging: Bool) //Allow you to drag the view, default is false
```

You can show and dismiss `DCDMagnifyingGlassView` using the following class methods:

```objective-c
//Set the frame of `DCDMagnifyingGlassView` and add it to the targetView
class func show(frame: CGRect) //No animation
class func show(frame: CGRect, animated: Bool)

//Dismiss `DCDMagnifyingGlassView` and remove it from the targetView
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

`DCDMagnifyingGlassView` is brought to you by David Dong

