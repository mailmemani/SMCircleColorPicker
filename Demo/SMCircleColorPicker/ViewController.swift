//
//  ViewController.swift
//  SMCircleColorPicker
//
//  Created by subramanian on 07/10/19.
//  Copyright © 2019 Subramanian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SMCircleColorPickerDelegate {

    @IBOutlet weak var colorSelector: SMCircleColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorSelector.colorPickerDelegate = self
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }

    func colorChanged(color: UIColor) {
        self.view.backgroundColor = color
    }

}

