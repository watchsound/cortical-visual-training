//
//  ColorPicker.swift
//  cortical visual training
//
//  Created by Hanning Ni on 12/2/15.
//  Copyright (c) 2015 Love. All rights reserved.
//

import Foundation
import UIKit

protocol ColorPickerDelegate :NSObjectProtocol{
    func colorSelected(color: UIColor);
    
}

class ColorPicker : UIViewController {
    
    var delegate : ColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func redClicked(sender: AnyObject) {
        delegate!.colorSelected(UIColor.redColor())
    }
    @IBAction func yellowClicked(sender: AnyObject) {
        delegate!.colorSelected(UIColor.yellowColor())
    }
    @IBAction func greenClicked(sender: AnyObject) {
         delegate!.colorSelected(UIColor.greenColor())
    }
    
    @IBAction func blueClicked(sender: AnyObject) {
         delegate!.colorSelected(UIColor.blueColor())
    }
    @IBAction func blackClicked(sender: AnyObject) {
         delegate!.colorSelected(UIColor.blackColor())
    }
}