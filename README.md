# DCDMagnifyingGlassView

Magnify your views anywhere, at anytime, using **`DCDMagnifyingGlassView`**!

Text                                        |Image
:------------------------------------------:|:------------------------------------------:
![DCDMagnifyingGlass Demo](https://github.com/c9dong/DCDMagnifyingGlassView/blob/master/Images/DCDMagnifyingGlassVideo1.gif)|![DCDMagnifyingGlass Demo] (https://github.com/c9dong/DCDMagnifyingGlassView/blob/master/Images/DCDMagnifyingGlassVideo2.gif)

## How to Use

You can configure **`DCDMagnifyingGlassView`** using the following class methods:

```objective-c
//The view to magnify, uses the top window as default
class func setTargetView(targetView: UIView)

//How much you want to magnify the view, default is 2x
class func setScale(scale: CGFloat)

//Allow you to drag the view, default is false
class func allowDragging(allowDragging: Bool)

//Allows you to set the frame of the view. The size of the frame will always convert to a square, 
//with size = MIN(width, height). Default is (100,100,100,100)
class func setContentFrame(frame: CGRect)
```

You can show and dismiss **`DCDMagnifyingGlassView`** using the following class methods:

```objective-c
//Set the frame of DCDMagnifyingGlassView and add it to the targetView
class func show(animated: Bool)

//Dismiss DCDMagnifyingGlassView and remove it from the targetView
class func dismiss(animated: Bool);
```

## Example Code Using Swift

```objective-c
override func viewDidLoad(){
  super.viewDidLoad()
  DCDMagnifyingGlassView.setTargetView(self.view)
  DCDMagnifyingGlassView.setScale(5.0)
  DCDMagnifyingGlassView.allowDragging(true)
  DCDMagnifyingGlassView.setContentFrame(CGRect(x: 115,y: 90,width:  100,height: 100))
  
  //Initialize views
  ...
}

func showButtonClicked(sender: UIButton){
  DCDMagnifyingGlassView.show(true)
}

func hideButtonClicked(sender: UIButton){
  DCDMagnifyingGlassView.dismiss(true)
}
```

## Credit

**`DCDMagnifyingGlassView`** is brought to you by David Dong

