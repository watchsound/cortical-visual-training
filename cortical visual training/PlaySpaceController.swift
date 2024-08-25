//
//  PlaySpaceController.swift
//  cortical visual training
//
//  Created by Hanning Ni on 12/1/15.
//  Copyright (c) 2015 Love. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class PlaySpaceController : UIViewController ,FPPopoverContentControllerDelegate, ColorPickerDelegate, StrokeWidthPickerDelegate, EdgeDetectorSettingPanelDelegate{
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var scratchPanel: TouchDrawView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var highligtBarItem: UIBarButtonItem!
    @IBOutlet var undoBarItem: UIBarButtonItem!
    @IBOutlet var strokeWidthBarItem: UIBarButtonItem!
     @IBOutlet var colorBarItem: UIBarButtonItem!
     @IBOutlet var clearBarItem: UIBarButtonItem!
    
    @IBOutlet var colorButton: UIButton!
    @IBOutlet var strokeWidthButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var highlightButton: UIButton!
    
    @IBOutlet var settingBarItem: UIBarButtonItem!
    
    
    @IBOutlet var settingButton: UIButton!
    
    var imageRecord : ImageRecord?
    var currentFilteredImage : UIImage?
    var inputImage : UIImage?
    var flashHighlight = true
    
    var popoverWindow : FPPopoverController?
    var colorPanel : ColorPicker?
    var strokeWidthPanel : StrokeWidthPicker?
    var edgetSettingPanel : EdgeDetectorSettingPanel?
    
    @IBAction func strokeButtonClicked(sender: AnyObject) {
        let popupview = getStrokeWidthPanel()
        popoverWindow = FPPopoverController( viewController: popupview )
        var screenWidth = self.view.frame.size.width
        popupview.view.frame.size = CGSizeMake(230, 65)
        popoverWindow!.contentSize = CGSizeMake(230 + 50,  65+40)
        popoverWindow!.border = false;
        popoverWindow!.presentPopoverFromView( strokeWidthButton )
    }
    @IBAction func colorButtonClicked(sender: AnyObject) {
        let popupview = getColorPanel()         
        popoverWindow = FPPopoverController( viewController: popupview )
        var screenWidth = self.view.frame.size.width
        popupview.view.frame.size = CGSizeMake(275, 65)
        popoverWindow!.contentSize = CGSizeMake(275 + 50,  65+40)
        popoverWindow!.border = false;
        popoverWindow!.presentPopoverFromView( colorButton )
    }
    
    @IBAction func clearButtonClicked(sender: AnyObject) {
        scratchPanel.clearAll()
    }
    
    @IBAction func undoButtonClicked(sender: AnyObject) {
        scratchPanel.undo()
    }
    @IBAction func highlightButtonClicked(sender: AnyObject) {
        if flashHighlight {
            flashHighlight = false
           
        } else {
            flashHighlight = true
            startFlashHighligh(100)
        }
        
    }
    
    @IBAction func settingButtonClicked(sender: AnyObject) {
        let popupview = getEdgeSettingPanel()
        popoverWindow = FPPopoverController( viewController: popupview )
        var screenWidth = self.view.frame.size.width
        popupview.view.frame.size = CGSizeMake(300, 100)
        popoverWindow!.contentSize = CGSizeMake(300 + 50,  100+40)
        popoverWindow!.border = false;
        popoverWindow!.presentPopoverFromView( settingButton )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //not sure why not work here...
       // customNavigationBarLayout()
        highligtBarItem.customView = highlightButton
        undoBarItem.customView = undoButton
        clearBarItem.customView = clearButton
        colorBarItem.customView = colorButton
        strokeWidthBarItem.customView = strokeWidthButton
        settingBarItem.customView = settingButton
        
        
        inputImage = DataManager.shared.loadImageIcon( imageRecord! )
        background.image = inputImage
        
        setupFilter(true)
        
        loadCustomDrawing()
        
         menuButton.addTarget(self , action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func revealToggle(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadCustomDrawing(){
        scratchPanel.loadFromFile( DataManager.shared.getEditImageName(imageRecord!.name) )
    }
    
    
    func setupFilter(startFlash:Bool) {
    
        var stillImageSource : GPUImagePicture  =   GPUImagePicture(image: inputImage)
       //  [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
        var filter : GPUImageSobelEdgeDetectionFilter  =  GPUImageSobelEdgeDetectionFilter()
    //  [filter forceProcessingAtSize:self.primaryView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
        filter.edgeStrength = (CGFloat)(imageRecord!.edgeStrength)
        
        stillImageSource.addTarget( filter )
        filter.useNextFrameForImageCapture()
        stillImageSource.processImage()
    
         currentFilteredImage = filter.imageFromCurrentFramebuffer()
    
        if startFlash {
            startFlashHighligh(100)
        }
    
    }
    
    func startFlashHighligh(alpha : UInt32) {
        if !flashHighlight {
            self.background.image =  self.inputImage
            return;
        }
        self.background.alpha = 1
        UIView.animateWithDuration(0.5, delay:0.01,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
              self.background.alpha = 0.9
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(1, animations:{
                    ()-> Void in
                    let processor : ImageProcessor  =  ImageProcessor.sharedProcessor()
                    processor.strokeWidth =  Int32( self.imageRecord!.edgeStrokeWidth )
                    self.background.image =  processor.processImage(self.inputImage, overlay: self.currentFilteredImage, alpha:alpha)
                    var newvalue : UInt32  = alpha + 50;
                    if ( newvalue > 255 ){
                         self.startFlashHighligh(0)
                    } else {
                         self.startFlashHighligh(newvalue)
                    }
                })
        })
    }
    
   //MARK == protocol EdgeDetectorSettingPanelDelegate :NSObjectProtocol{
    func edgeDetectingStrokeWidthChanged(strokeWidth: Int){
        if let popup = popoverWindow {
            popup.dismissPopoverAnimated(true)
        }
        
        imageRecord!.edgeStrokeWidth = strokeWidth
        R9DBConnectionManager.shared.updateEdgeDetectSetting(imageRecord!)
       
    }
    
    func edgeDetectingEdgeStrengthChanged(edgeStrength : CGFloat){
        if let popup = popoverWindow {
            popup.dismissPopoverAnimated(true)
        }
        
        imageRecord!.edgeStrength = Double( edgeStrength )
        R9DBConnectionManager.shared.updateEdgeDetectSetting(imageRecord!)
        setupFilter(false)
    }

    
   //MARK = FPPopoverContentControllerDelegate
    func rowSelected( option : AnyObject){
        let aoption = option as! Option
    }
    
    //MARK = ColorPickerDelegate :NSObjectProtocol{
    func colorSelected(color: UIColor){
        scratchPanel.drawColor = color
        if let popup = popoverWindow {
            popup.dismissPopoverAnimated(true)
        }
    }
    
    func widthSelected(width: Int32){
        scratchPanel.strokeWidth = width
        if let popup = popoverWindow {
            popup.dismissPopoverAnimated(true)
        }
    }
    
    
    func getColorPanel() -> ColorPicker {
        if let controller = self.colorPanel { //should use GUARD pattern?
            
        } else {
            self.colorPanel = (storyboard?.instantiateViewControllerWithIdentifier("ColorPicker") as! ColorPicker)
            self.colorPanel?.delegate = self
            
        }
        return self.colorPanel!
    }
    
    func getStrokeWidthPanel() -> StrokeWidthPicker {
        if let controller = self.strokeWidthPanel { //should use GUARD pattern?
            
        } else {
            self.strokeWidthPanel = (storyboard?.instantiateViewControllerWithIdentifier("StrokeWidthPicker") as! StrokeWidthPicker)
            self.strokeWidthPanel?.delegate = self
            
        }
        return self.strokeWidthPanel!
    }
    
    func getEdgeSettingPanel() -> EdgeDetectorSettingPanel {
        if let controller = self.edgetSettingPanel { //should use GUARD pattern?
            
        } else {
            self.edgetSettingPanel = (storyboard?.instantiateViewControllerWithIdentifier("EdgeDetectorSettingPanel") as! EdgeDetectorSettingPanel)
            self.edgetSettingPanel?.delegate = self
            
        }
        return self.edgetSettingPanel!
    }

    
    
    func customNavigationBarLayout() {
     
       self.navigationController!.navigationBar.translucent = false;
      // self.navigationController.navigationBar.setBarTintColor( UIColor.lightGrayColor() )
        addRightBarButtonItems()
    
    }
    
    func addRightBarButtonItems() {
    
        var fixedItem : UIBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        fixedItem.width = 30
        
        var undoButton : UIButton = UIButton()
        undoButton.addTarget(self, action:"undoClicked:", forControlEvents:UIControlEvents.TouchUpInside)
        undoButton.setTitle("Undo", forState: UIControlState.Normal)
        
        var clearButton : UIButton = UIButton()
        clearButton.addTarget(self, action:"ClearClicked:", forControlEvents:UIControlEvents.TouchUpInside)
        clearButton.setTitle("Clear", forState: UIControlState.Normal)
        
     
        var barButtonUndo : UIBarButtonItem = UIBarButtonItem(customView:undoButton)
        var barButtonClear : UIBarButtonItem = UIBarButtonItem(customView:clearButton)
      
        var  arrayButtons : [UIBarButtonItem] = [barButtonUndo, fixedItem, barButtonClear]
        self.navigationItem.setRightBarButtonItems(arrayButtons, animated: false)
    }

    func undoClicked(sender : AnyObject ){
        scratchPanel.undo()
    }

    func ClearClicked(sender : AnyObject ){
        scratchPanel.clearAll()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if ( scratchPanel.hasContents() ){
            scratchPanel.saveToFile( DataManager.shared.getEditImageName(imageRecord!.name))
            R9DBConnectionManager.shared.editImage(imageRecord!)
        }
    }
    
}
    