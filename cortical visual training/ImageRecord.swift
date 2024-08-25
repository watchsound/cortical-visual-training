//
//  ImageRecord.swift
//  cortical visual training
//
//  Created by Hanning Ni on 12/1/15.
//  Copyright (c) 2015 Love. All rights reserved.
//

import Foundation


public class ImageRecord : NSObject {
    var unitId : Int64 = 0
    var name : String = ""
    var fromAssets : Bool = false
    var hasDrawing : Bool = false
    var lastEditTime : Double = 0
    
    var edgeStrokeWidth : Int = 2    //1, 2, 3
    var edgeStrength : Double = 1      // 0.7 - 1
}