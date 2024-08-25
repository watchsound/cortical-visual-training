//
//  R9DBConnectionManager.swift
//  StudyPad
//
//  Created by Hanning Ni on 8/1/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation


public class R9DBConnectionManager {
    
    //通过关键字static来保存实例引用
    private static let instance = R9DBConnectionManager()
    
    //私有化构造方法
    private init() {
    }
    
    //提供静态访问方法
    public static var shared: R9DBConnectionManager {
        return self.instance
    }
 
    
    public func getDatabase() -> Database {
   
        let path = NSSearchPathForDirectoriesInDomains(
                .DocumentDirectory, .UserDomainMask, true
                ).first as! String
    
        var db : Database =  Database("\(path)/db.sqlite3")
        
//        var unitId : Int = 0
//        var name : String = ""
//        var fromAssets : Bool = false
//        var hasDrawing : Bool = false
//        var lastEditTime : Double = 0
//        var edgeStrokeWidth : Int32 = 1    //1, 2, 3
//        var edgeStrength : Double = 1      // 0.7 - 1
        
        db.execute(
            "CREATE TABLE IF NOT EXISTS \"image_record\" (" +
                "unit_id integer primary key autoincrement, " +
            "name varchar(64), " +
            "from_assets integer, " +
            "has_drawing integer, " +
            "last_edit_time DOUBLE, " +
            "edge_stroke_width integer DEFAULT 2, " +
            "edge_strength DOUBLE DEFAULT 1" +
            ")"
        )
        
        
        return db
    }
    
    //        var unitId : Int = 0
    //        var name : String = ""
    //        var fromAssets : Bool = false
    //        var hasDrawing : Bool = false
    //        var lastEditTime : Double = 0
    //        var edgeStrokeWidth : Int32 = 1    //1, 2, 3
    //        var edgeStrength : Double = 1      // 0.7 - 1
    
    public func populateLearningUnitsFromAssets(imageRecords :NSArray)->Void {
        let db : Database = getDatabase()
        
        
        var unit : AnyObject
        for  unit in imageRecords {
             var record : ImageRecord = unit as! ImageRecord
            save( record, db: db)
        }
    }
    
    private func save(record:ImageRecord, db : Database) {
        let jr :Statement = db.prepare( "INSERT INTO image_record ( name, from_assets, has_drawing, last_edit_time, edge_stroke_width, edge_strength ) VALUES (?, ?, ?, ?, ?, ?)" )
        jr.run( record.name, record.fromAssets ? 1 : 0, record.hasDrawing ? 1 : 0, record.lastEditTime , record.edgeStrokeWidth, record.edgeStrength)
    }
    
    public func getImageRecordById(_unitId :Int64)-> ImageRecord? {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["image_record"]
        let unit_id = Expression<Int64>("unit_id")
        let updaterow = learning_units_tb.filter(unit_id == _unitId)
        
        for row in updaterow {
            return mapQueryRowToImageRecord( row )
        }
        
        return nil
    }
    
    public func saveImageRecord(fileName: String) -> ImageRecord {
        var record = ImageRecord()
        record.name = fileName;
        record.hasDrawing = false
        record.fromAssets = false
        
        let db : Database = getDatabase()
        save( record, db: db)
        return record;
    }
    
    
    public func editImage(learningUnits :ImageRecord )->Void {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["image_record"]
        let unit_id = Expression<Int64>("unit_id")
 
        let bookmarked = Expression<Int>("has_drawing")
        let last_edit_time = Expression<Double>("last_edit_time")
      
        let updaterow = learning_units_tb.filter(unit_id == learningUnits.unitId)
        updaterow.update( bookmarked <- 1 , last_edit_time <- NSDate().timeIntervalSince1970)
        learningUnits.hasDrawing = true
        
    }
    
    public func updateEdgeDetectSetting(learningUnits :ImageRecord )->Void {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["image_record"]
        let unit_id = Expression<Int64>("unit_id")
        
        let edgeStrokeWidth = Expression<Int>("edge_stroke_width")
        let edgeStrength = Expression<Double>("edge_strength")
        
        let updaterow = learning_units_tb.filter(unit_id == learningUnits.unitId)
        updaterow.update( edgeStrokeWidth <- learningUnits.edgeStrokeWidth , edgeStrength <- learningUnits.edgeStrength )
       
        
    }
    
    public func mapQueryRowToImageRecord( learningunit_row :Row ) -> ImageRecord{
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["image_record"]
        let unit_id = Expression<Int64>("unit_id")
        let name = Expression<String>("name")
        let from_assets = Expression<Int>("from_assets")
        let has_drawing = Expression<Int>("has_drawing")
        let last_edit_time = Expression<Double>("last_edit_time")
        let edgeStrokeWidth = Expression<Int>("edge_stroke_width")
        let edgeStrength = Expression<Double>("edge_strength")
        
        
            var learningUnit : ImageRecord = ImageRecord()
            learningUnit.unitId  = learningunit_row[unit_id]
         learningUnit.name  = learningunit_row[name]
             learningUnit.fromAssets  = learningunit_row[from_assets] == 1
            learningUnit.hasDrawing  = learningunit_row[has_drawing] == 1
           learningUnit.lastEditTime =  learningunit_row[last_edit_time]
             learningUnit.edgeStrokeWidth =  learningunit_row[edgeStrokeWidth]
             learningUnit.edgeStrength =  learningunit_row[edgeStrength]
        
        return learningUnit
    }
    
    
    
    public func populateImageRecordsFromDatabase( )->[ImageRecord] {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["image_record"]
       
        var result : [ImageRecord] = []
        for learningunit_row  in learning_units_tb {
            let row =  mapQueryRowToImageRecord( learningunit_row )
            result.append( row )
        }
        return result
    }
    
  
}