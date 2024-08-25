//
//  DataManager.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/31/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation

public class DataManager {
    
    //通过关键字static来保存实例引用
    private static let instance = DataManager()
    
    //私有化构造方法
    private init() {
    }
    
    //提供静态访问方法
    public static var shared: DataManager {
        return self.instance
    }
    
    public func tryToPopulateDatabaseFromAssets() -> Void{
        if  R9Properties.shared.getAppStatus() > 0 { return };
        R9Properties.shared.setAppStatus(1);
        
        var metaData : [ImageRecord] = tryToReadLearningUnitsFromAssets()
       
        R9DBConnectionManager.shared.populateLearningUnitsFromAssets( metaData )
    }
    
    public func tryToReadLearningUnitsFromAssets() -> [ImageRecord]{
        var result : [ImageRecord] = []
        var dataPath : String = NSBundle.mainBundle().resourcePath!
        dataPath = dataPath.stringByAppendingPathComponent("r9data");
        
        var dirList : [AnyObject] = NSFileManager.defaultManager().contentsOfDirectoryAtPath(dataPath, error: nil)!
        var file : AnyObject;
        for   file in dirList {
            var filename : String = file as! String
            
            var record = ImageRecord()
            record.name = filename
            record.fromAssets = true
            record.hasDrawing = false
            result.append(record)
        }
        return result
    }
    
    public func getEditImageName(imageName : String) -> String {
        return  "_edit_\(imageName)"
    }
     
    
    
    public func loadEditImageIcon(imageName:String) -> UIImage? {
        var filename = getEditImageName(imageName)
        var dataPath : String = getResourcePathInDoc(filename, createDirectory : false)
        return loadImageIconFromPath( dataPath )
        
    }
    
    public func loadImageIcon(imageRecord:ImageRecord) -> UIImage? {
        if imageRecord.fromAssets {
             var dataPath : String = getPathForImageInAssets(imageRecord.name)
            return loadImageIconFromPath( dataPath )
        } else {
            var dataPath : String = getResourcePathInDoc(imageRecord.name, createDirectory : false)
            return loadImageIconFromPath( dataPath )
        }
    }
    
    public func saveImage(image: UIImage) ->ImageRecord {
        let name =  NSUUID().UUIDString
        var dataPath : String = getResourcePathInDoc(name, createDirectory : false)
        var binaryImageData : NSData = UIImagePNGRepresentation(image);
        
        binaryImageData.writeToFile(dataPath, atomically:true)
        
        return R9DBConnectionManager.shared.saveImageRecord(name)
    }
    
    
    
    public func getPathForImageInAssets(learningUnitFolderName:String ) -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("r9data")
            .stringByAppendingPathComponent(learningUnitFolderName)
    }
    
    public func loadImageIconFromPath(dataPath:String) -> UIImage? {
        
        if  NSFileManager.defaultManager().fileExistsAtPath(dataPath)  {
            return UIImage(contentsOfFile: dataPath)!;
        } else {
            return nil
        }
    
    }
    
    public func getResourcePathInDoc(resouesName : String , createDirectory : Bool ) -> String {
        var fileManager = NSFileManager.defaultManager()
        var error : NSError
        var path  = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        var documentsDirectory: AnyObject = path[0]
        var filePath = documentsDirectory.stringByAppendingPathComponent(resouesName )
        var success : Bool  = fileManager.fileExistsAtPath(filePath)
        if !success &&  createDirectory {
            fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil, error: nil) //Create folder
        }
        return filePath
    }

   
}