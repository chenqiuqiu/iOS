//
//  LoginViewController.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/3/27.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON


let WHITEVIEW_FRAME = kmainWidth-70

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //var userInfoDic : NSMutableDictionary?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        let whiteView = UIView()
//        whiteView.frame = self.view.bounds
//        whiteView.backgroundColor = UIColor.white;
//        whiteView.alpha = 0.8;
//        self.view.addSubview(whiteView);
        
        
        let icon = UIImageView(image:UIImage(named:"logo.png"))
        icon.frame = CGRect(x:kmainWidth/2-65,y:20,width:65,height:65)
        self.view.addSubview(icon)
        
        //添加两个输入框
        self.createTextFeild()
        
    }


    func createTextFeild(){
        
        //手机输入框
        let phoneTF = UITextField(frame:CGRect(x:15,y:160,width:WHITEVIEW_FRAME-30,height:30))
        //phoneTF.backgroundColor = UIColor.blue;
        phoneTF.placeholder = "输入手机号"
        let leftView = UIView(frame:CGRect(x:0,y:0,width:30,height:30))
        let userImgView = UIImageView(image:UIImage(named:"user.png"))
        userImgView.frame = CGRect(x:0,y:2,width:20,height:18)
        leftView.addSubview(userImgView)
        phoneTF.leftView = leftView
        phoneTF.leftViewMode = UITextFieldViewMode.always
        phoneTF.setValue(UIFont.systemFont(ofSize: 13), forKeyPath:"_placeholderLabel.font")
        phoneTF.delegate = self
        phoneTF.tag = 1000
        self.view.addSubview(phoneTF)
        
        
        //密码输入框
        let passTF = UITextField(frame:CGRect(x:15,y:210,width:WHITEVIEW_FRAME-30,height:30))
       // passTF.backgroundColor = UIColor.blue
        passTF.placeholder = "输入密码(数字/字母,6-12位)"
        self.view.addSubview(passTF)
        let leftView2 = UIView(frame:CGRect(x:0,y:0,width:30,height:30))
        let passImgView = UIImageView(frame:CGRect(x:0,y:2,width:20,height:20))
        passImgView.image = UIImage(named:"key.png")
        leftView2.addSubview(passImgView)
        passTF.leftView = leftView2
        passTF.leftViewMode = UITextFieldViewMode.always
        passTF.setValue(UIFont.systemFont(ofSize: 13), forKeyPath: "_placeholderLabel.font")
        passTF.delegate = self
        passTF.tag = 1001
       // var i = 0;
        
        for  index in 0...1{
            
            let line = UIView(frame:CGRect(x:15.00000,y:190.0000000+50.545654*Double(index),width:Double(kmainWidth-100),height:1.5))
            line.backgroundColor = UIColor.white
            self.view.addSubview(line)
            
        }
        
        let loginButton = UIButton(frame:CGRect(x:20,y:kmainHeight*0.48,width:kmainWidth*5/7,height:40))
        loginButton.setTitle("登录", for:UIControlState.normal)
        loginButton.setTitleColor(logoColor, for: UIControlState.normal)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 1.5000
        loginButton.layer.borderColor = logoColor.cgColor
        loginButton.addTarget(self, action: #selector(getUserID), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        let tap = UITapGestureRecognizer(target:self,action:#selector(closeKeyboard))
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        self.view.addGestureRecognizer(tap)
    }

    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
   

    func getUserID() {
        let userTF = self.view.viewWithTag(1000) as! UITextField
        let passTF = self.view.viewWithTag(1001) as! UITextField
        
        let parameters = ["telephone": userTF.text!,"pwd":passTF.text!,"type":3] as [String : Any]
        
        let path = IPstress + "/langyang/Home/User/login"
        let manager = AFHTTPSessionManager()
        
        manager.securityPolicy.allowInvalidCertificates = true
        manager.post(path, parameters: parameters, progress: {
            (uploadProgress)->Void in
            
        }, success: {(operation:URLSessionDataTask,responseObject:Any?)->Void in
            print(responseObject!)
            
            //var json:Any? = JSONSerialization.jsonObject(with: JSON!, options: .allZeros)
            let userdata = try? JSONSerialization.data(withJSONObject: responseObject!, options: [])
            let json = JSON(data:userdata!)
            //let dataDic1 = responseObject as? [String : AnyObject]
            let dataDic = json["data"]
            let listArr = dataDic["list"]
            let iddic = listArr[0]
            let idStr = iddic["id"].string!
            print(idStr)
            UserDefaults.standard.set(idStr, forKey: "userID")
            UserDefaults.standard.synchronize()
        }, failure:{(failure)->Void in
        
        
        })

    
    
    }
    
    
    
    
    
    
    
    
    
    
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
