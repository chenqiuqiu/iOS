//
//  MacView.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/7/12.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
class MacView: UIView {

    var maclistArr : NSArray?
    /*
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
            self.maclistArr = listArr.array! as NSArray
            //semaphore.signal()
            UserDefaults.standard.set(self.maclistArr, forKey: "maclistArr")
        }, failure:{(failure)->Void in
            // semaphore.signal()
        })
        
        
    }
*/
    override init(frame:CGRect){
        //let infoArr = NSArray()
        super.init(frame: frame)
        self.afnetworking()
        
    }
    
    func afnetworking(){
       // var maclistArr : NSArray?
        
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
            self.maclistArr = listArr.array! as NSArray
            
            self.setupSubViews()
        }, failure:{(failure)->Void in
            // semaphore.signal()
        })
        
        
    }

    func setupSubViews() {
        let macScroll  = UIScrollView(frame:CGRect(x:0,y:0,width:kmainWidth,height:80))
        
        macScroll.contentSize = CGSize(width:100*(maclistArr?.count)!,height:80)
        macScroll.backgroundColor = UIColor.red
        self.addSubview(macScroll)
        
        for index in 0..<Int(maclistArr?.count){
            <#code#>
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init(coder aDecoder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
