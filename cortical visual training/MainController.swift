//
//  MainController.swift
//  cortical visual training
//
//  Created by Hanning Ni on 11/30/15.
//  Copyright (c) 2015 Love. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class MainController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageRecords : [ImageRecord] = []
    var newMedia: Bool?
    var selectedImageRecord : ImageRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageRecords = R9DBConnectionManager.shared.populateImageRecordsFromDatabase()
//        collectionView!.registerClass(ImageRecordCell.self, forCellWithReuseIdentifier: "ImageRecordCell")
//        collectionView!.registerClass(AddImageCell.self, forCellWithReuseIdentifier: "AddImageCell")
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageRecords.count + 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddCameraCell", forIndexPath: indexPath) as! AddCameraCell
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddImageCell", forIndexPath: indexPath) as! AddImageCell
            return cell
        } else   {
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageRecordCell", forIndexPath: indexPath) as! ImageRecordCell
              let record = imageRecords[ indexPath.row  - 2 ]
            cell.imageIcon.image = DataManager.shared.loadImageIcon(record)
             cell.imageIcon.layer.cornerRadius = 12.0
            cell.imageIcon.clipsToBounds = true
            // border
              cell.imageIcon.layer.borderWidth = 2
            cell.imageIcon.backgroundColor = UIColor.clearColor()
            if record.hasDrawing {
                cell.checkImageIcon.hidden = false
            } else {
                cell.checkImageIcon.hidden = true
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == 0 {
            useCamera( collectionView )
        } else if indexPath.row == 1 {
            useCameraRoll( collectionView )
        } else   {
            selectedImageRecord = imageRecords[ indexPath.row  - 2]
            performSegueWithIdentifier("to_playspace", sender:nil)
        }         
    }
    
    func resyncWithDatabase() {
        imageRecords = R9DBConnectionManager.shared.populateImageRecordsFromDatabase()
        collectionView.reloadData()
    }
    
    func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, 
                    completion: nil)
                newMedia = true
        }
    }
    
    func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            DataManager.shared.saveImage(image)
            resyncWithDatabase()
//            
//            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                    "image:didFinishSavingWithError:contextInfo:", nil)
//            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
//                // Code to support video here
//            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK
    //used for xcode... wired with navigation back event
    @IBAction func unwindBackToMainView(segue: UIStoryboardSegue) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        let segueName = segue.identifier
        var destination: AnyObject  = segue.destinationViewController;
        
        if destination.isKindOfClass(PlaySpaceController) {
            var controller : PlaySpaceController = destination as! PlaySpaceController
            
            
            if segue.identifier == "to_playspace" {
                controller.imageRecord = selectedImageRecord
            }
            
        }
        if destination.isKindOfClass(UINavigationController) {
            var navController : UINavigationController = destination as! UINavigationController
            
            
            if segue.identifier == "to_playspace" {
                var controller = navController.childViewControllers[0] as! PlaySpaceController
                controller.imageRecord = selectedImageRecord
            }
        }
       
    }

}
