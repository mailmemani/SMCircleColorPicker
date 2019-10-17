# SMCircleColorPicker

[![Build Status](https://travis-ci.org/mailmemani/SMCircleColorPicker.svg?branch=master)](https://travis-ci.org/mailmemani/SMCircleColorPicker)  [![Pod Status](https://img.shields.io/cocoapods/v/SMCircleColorPicker.svg?style=flat)](http://cocoapods.org/pods/SMCircleColorPicker) [![License](https://img.shields.io/cocoapods/l/SMCircleColorPicker.svg?style=flat)](https://github.com/mailmemani/SMCircleColorPicker/blob/master/LICENSE) [![License](https://img.shields.io/cocoapods/p/SMCircleColorPicker.svg?style=flat)](http://cocoapods.org/pods/SMCircleColorPicker)

SMCircleColorPicker is a circular colour picker and easy to customize.

### Features!
* Head control to rotate around a colour wheel to pick a colour
* Easy to customize number of colours in the wheel
* Easy to customize head control colour
* Easy to customize the head control and colour wheel spacing and size

### Requirement
* Swift 5
* Xcode 11

### Usage
![](https://raw.githubusercontent.com/mailmemani/SMCircleColorPicker/screeshots/gifs/demo.gif)

### How to use it

#### CocoaPods - Podfile

```sh
platform :ios, '9.0'
pod 'SMCircleColorPicker'
```

#### Install
```sh
$ pod install
```

### How to customize


#### Interface Builder
Layout, and color can be changed through the Interface Builder.

![](https://raw.githubusercontent.com/mailmemani/SMCircleColorPicker/screeshots/gifs/xib.gif)


### Protocol

`SMCircleColorPickerDelegate` delegate will update the respective instance about the colour changes while the user rotates the head

```sh
func colorChanged(color: UIColor)
```

### Integration

```sh
class BackgroundColorVC: UIViewController, SMCircleColorPickerDelegate {

    @IBOutlet weak var colorSelector: SMColorWheel!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorSelector.colorPickerDelegate = self
    }

    // MARK: SMColorWheelDelegate function
    func colorChanged(color: UIColor) {
        self.view.backgroundColor = color
    }
}
```

License
----

The MIT License (MIT) Copyright (c) 2019 https://github.com/mailmemani/SMCircleColorPicker

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
