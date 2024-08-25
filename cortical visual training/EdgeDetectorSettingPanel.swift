//
//  EdgeDetectorSettingPanel.swift
//  cortical visual training
//
//  Created by Hanning Ni on 12/2/15.
//  Copyright (c) 2015 Love. All rights reserved.
//

import Foundation
import UIKit

protocol EdgeDetectorSettingPanelDelegate :NSObjectProtocol{
    func edgeDetectingStrokeWidthChanged(strokeWidth: Int);
    func edgeDetectingEdgeStrengthChanged(edgeStrength : CGFloat);
    
}

class EdgeDetectorSettingPanel : UIViewController {
    
    var delegate : EdgeDetectorSettingPanelDelegate?
    
    var _strokeWidth: Int?
    var _edgeStrength : CGFloat?
    
    
    @IBAction func w2Clicked(sender: AnyObject) {
        if ( _strokeWidth == 1 ){
            return ;
        }
        delegate!.edgeDetectingStrokeWidthChanged(1)
    }
    @IBAction func w4Clicked(sender: AnyObject) {
        if ( _strokeWidth == 2 ){
            return ;
        }
        delegate!.edgeDetectingStrokeWidthChanged(2)
    }
    @IBAction func w6Clicked(sender: AnyObject) {
        if ( _strokeWidth == 3 ){
            return ;
        }
        delegate!.edgeDetectingStrokeWidthChanged(3)
    }
     
    @IBAction func s2Clicked(sender: AnyObject) {
        if ( _edgeStrength == 0.7 ){
            return
        }
        delegate!.edgeDetectingEdgeStrengthChanged(0.7)
    }
    
    @IBAction func s4Clicked(sender: AnyObject) {
        if ( _edgeStrength == 0.8 ){
            return
        }
         delegate!.edgeDetectingEdgeStrengthChanged(0.8)
    }
    @IBAction func s6Clicked(sender: AnyObject) {
        if ( _edgeStrength == 0.9 ){
            return
        }
         delegate!.edgeDetectingEdgeStrengthChanged(0.9)
    }
    @IBAction func s8Clicked(sender: AnyObject) {
        if ( _edgeStrength == 1 ){
            return
        }
         delegate!.edgeDetectingEdgeStrengthChanged(1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUpInitialValue(strokeWidth: Int, edgeStrength : CGFloat){
        _strokeWidth = strokeWidth
        _edgeStrength = edgeStrength
       
    }
  
}