//
//  LocationModel.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/7/10.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
class LocationModel: NSObject {
    

    
    func afnetworking(){
        
        
        let userid = UserDefaults.standard.value(forKey: "userID")
        let parameters = ["userid": userid]
        
        let path = IPstress + "/langyang/Home/User/getDeviceList"
        let manager = AFHTTPSessionManager()
        
        manager.securityPolicy.allowInvalidCertificates = true
        //let semaphore = DispatchSemaphore(value : 0)
        
            manager.post(path, parameters: parameters, progress: {
                (uploadProgress)->Void in
                
            }, success: {(operation:URLSessionDataTask,responseObject:Any?)->Void in
                //print(responseObject!)
                
                //var json:Any? = JSONSerialization.jsonObject(with: JSON!, options: .allZeros)
                let userdata = try? JSONSerialization.data(withJSONObject: responseObject!, options: [])
                let dataData = JSON(data:userdata!)
                let listData = dataData["data"]
                let listArr = listData["list"]
                let maclistArr = listArr.array! as NSArray
                //semaphore.signal()
                UserDefaults.standard.set(maclistArr, forKey: "maclistArr")
            }, failure:{(failure)->Void in
                // semaphore.signal()
            })
            

    }
   
}






