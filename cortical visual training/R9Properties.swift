//
//  R9Properties.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/31/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation
import StoreKit

public class R9Properties {
    
    //通过关键字static来保存实例引用
    private static let instance = R9Properties()
    
    //私有化构造方法
    private init() {
    }
    
    //提供静态访问方法
    public static var shared: R9Properties {
        return self.instance
    }
    
    
    func getUsername() -> String{
        if let name =  NSUserDefaults.standardUserDefaults().stringForKey( "username" ) {
            return name
        }
        return ""
    }
    func setUsername(name :String) {
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "username");
    }
    
    func getAppStatus() -> Int{
        return  NSUserDefaults.standardUserDefaults().integerForKey("appStatus");
    }
    
    func setAppStatus(name :Int) {
        NSUserDefaults.standardUserDefaults().setInteger(name, forKey: "appStatus");
    }
    
    // 0 -> unpaid  1 -> failed  2 -> in progress  3 -> paid
    func getPaymentStatus() -> Int{
        return  NSUserDefaults.standardUserDefaults().integerForKey("paymentStatus");
    }
    
    func setPaymentStatus(name :Int) {
        NSUserDefaults.standardUserDefaults().setInteger(name, forKey: "paymentStatus");
    }
    
     // 0 -> unpaid  1 -> failed  2 -> in progress  3 -> paid
    func setPaymentStatusEnum(t :SKPaymentTransactionState?) {
        if ( t == nil ){
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "paymentStatus");
            return
        }
        var value  = 0;
        switch (t!)
        {
        case SKPaymentTransactionState.Purchasing:      //商品添加进列表
           value = 1
           break;
        case SKPaymentTransactionState.Purchased: //交易完成
            value = 2
            break;
        case SKPaymentTransactionState.Failed://交易失败
           value = 3
            break;
        case SKPaymentTransactionState.Restored://已经购买过该商品
           value = 4
            break;
      
        case SKPaymentTransactionState.Deferred:      //商品添加进列表
            value = 5
            break;
        default:
            break;
        }
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "paymentStatus");
    }
    
    // 0 -> unpaid  1 -> failed  2 -> in progress  3 -> paid
    func getPaymentStatusEnum() -> SKPaymentTransactionState?{
        let t =  NSUserDefaults.standardUserDefaults().integerForKey("paymentStatus");
        var value : SKPaymentTransactionState?
        switch (t)
        {
        case 1:      //商品添加进列表
            value = SKPaymentTransactionState.Purchasing
            break;
        case 2: //交易完成
            value = SKPaymentTransactionState.Purchased
            break;
        case 3://交易失败
            value = SKPaymentTransactionState.Failed
            break;
        case 4://已经购买过该商品
            value = SKPaymentTransactionState.Restored
            break;
            
        case  5 :    //商品添加进列表
            value = SKPaymentTransactionState.Deferred
            break;
        default:
            break;
        }
        return value
    }

        
    func getTotalStudyTime() -> Double{
        return  NSUserDefaults.standardUserDefaults().doubleForKey("totalStudyTime");
    }
    func addStudyTtime(time : Double ){
        var total : Double = getTotalStudyTime() + time
        setTotalStudyTime(total)
    }
    
    func setTotalStudyTime(name :Double) {
        NSUserDefaults.standardUserDefaults().setDouble(name, forKey: "totalStudyTime");
    }
    
    func getSummary() -> String{
        if let  summary  =  NSUserDefaults.standardUserDefaults().stringForKey( "summary" ){
            return summary
        }
        return ""
    }
    func setSummary(name :String) {
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "summary");
    }
    
    
    func getLastAccess() -> Int64{
        if let value =  NSUserDefaults.standardUserDefaults().objectForKey( "lastAccess" ) {
            let number =  value as! NSNumber
            return number.longLongValue
        }
        return  -1;
    }
    
    func setLastAccess(unitId :Int64) {
        NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: unitId), forKey: "lastAccess");
    }


 }