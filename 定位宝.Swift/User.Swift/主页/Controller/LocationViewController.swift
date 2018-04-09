//
//  LocationViewController.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/7/10.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON


class LocationViewController: UIViewController ,BMKMapViewDelegate{
    var _mapView : BMKMapView?
    //MARK: Life-Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        self._mapView = BMKMapView()
        _mapView = BMKMapView(frame:CGRect(x:0,y:0,width:kmainWidth,height:kmainHeight))
        //_mapView?.viewWillAppear()
         self.view.addSubview(_mapView!)
        
        
        let macView = MacView()
        _mapView?.addSubview(macView)
        
        
        
        
       
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
    }
    
    
    
    /*
    func afnetworking() -> (NSDictionary){
        let macDic = NSDictionary()
        
        let userid = UserDefaults.standard.value(forKey: "userID")
        
        let parameters = ["userid": userid]
        
        let path = IPstress + "/langyang/Home/User/getDeviceList"
        let manager = AFHTTPSessionManager()
        
        manager.securityPolicy.allowInvalidCertificates = true
        manager.post(path, parameters: parameters, progress: {
            (uploadProgress)->Void in
            
        }, success: {(operation:URLSessionDataTask,responseObject:Any?)->Void in
            //print(responseObject!)
            
            //var json:Any? = JSONSerialization.jsonObject(with: JSON!, options: .allZeros)
            let userdata = try? JSONSerialization.data(withJSONObject: responseObject!, options: [])
            let dataDic = JSON(data:userdata!)
            //print(dataDic)
            // macDic = dataDic["data"]
            
        }, failure:{(failure)->Void in
            
            
        })
        return macDic
    }
*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
