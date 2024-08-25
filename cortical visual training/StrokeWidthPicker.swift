//
//  StrokeWidthPicker.swift
//  cortical visual training
//
//  Created by Hanning Ni on 12/2/15.
//  Copyright (c) 2015 Love. All rights reserved.
//

import Foundation
import UIKit

protocol StrokeWidthPickerDelegate :NSObjectProtocol{
    func widthSelected(width: Int32);
    
}

class StrokeWidthPicker : UIViewController {
    
    var delegate : StrokeWidthPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func w2Clicked(sender: AnyObject) {
        delegate!.widthSelected(2)
    }
    @IBAction func w4Clicked(sender: AnyObject) {
        delegate!.widthSelected(6)
    }
    @IBAction func w6licked(sender: AnyObject) {
        delegate!.widthSelected(10)
    }
    
    @IBAction func w8Clicked(sender: AnyObject) {
        delegate!.widthSelected(20)
    }
    
}