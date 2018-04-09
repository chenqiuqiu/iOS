//
//  RegistViewController.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/3/28.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit



class RegistViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        
        //logo
        let icon = UIImageView(frame:CGRect(x:kmainWidth/2-65,y:20,width:65,height:65))
        icon.image = UIImage(named:"logo.png")
        self.view.addSubview(icon)
        
        self.textFeildInit()
      
    }
    
    
    
    func textFeildInit(){
        for index in 0...3 {
            let line = UIView(frame:CGRect(x:15.000,y:170.000+50*Double(index),width:Double(kmainWidth-80),height:1.3333))
            line.backgroundColor = UIColor.white
            self.view.addSubview(line)
            
            let placeholderArr:Array = ["输入手机号","输入验证码","数字／字母，6-12位","再次输入"]
            let imgnameArr:Array = ["user.png","baohu.png","key.png","key.png"]
            
            
            //做四个输入框
            let textTF = UITextField(frame:CGRect(x:15,y:140+50*index,width:Int(WHITEVIEW_FRAME-30),height:30))
            //phoneTF.backgroundColor = UIColor.blue;
            textTF.placeholder = placeholderArr[index]
            let leftView = UIView(frame:CGRect(x:0,y:0,width:30,height:30))
            let userImgView = UIImageView(image:UIImage(named:imgnameArr[index]))
            userImgView.frame = CGRect(x:0,y:2,width:20,height:18)
            leftView.addSubview(userImgView)
            textTF.leftView = leftView
            textTF.leftViewMode = UITextFieldViewMode.always
            textTF.setValue(UIFont.systemFont(ofSize: 13), forKeyPath:"_placeholderLabel.font")
            self.view.addSubview(textTF)
            
        }
        let identyButton = UIButton(frame:CGRect(x:WHITEVIEW_FRAME-80,y:185,width:85,height:25))
        identyButton.setTitle("获取验证码", for: .normal)
        identyButton.setTitleColor(logoColor, for: .normal)
        identyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        identyButton.layer.cornerRadius = identyButton.frame.size.height/2
        identyButton.layer.borderColor = logoColor.cgColor
        identyButton.layer.borderWidth = 1.5;
        self.view.addSubview(identyButton)
        
        let agreeLabel = UILabel(frame:CGRect(x:WHITEVIEW_FRAME-181,y:330,width:190,height:15))
        agreeLabel.textAlignment = NSTextAlignment.right
        //agreeLabel.text = "同意《服务条款》和《用户协议》"
        //agreeLabel.backgroundColor = UIColor.red
        agreeLabel.textColor = UIColor.init(white: 0.6, alpha: 1)
        agreeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        self.view.addSubview(agreeLabel)
        
        let str = "同意《服务条款》和《用户协议》"
        let mutableStr = NSMutableAttributedString.init(string: str)
        mutableStr.addAttribute(NSForegroundColorAttributeName, value: logoColor, range: NSMakeRange(2, 6))
        mutableStr.addAttribute(NSForegroundColorAttributeName, value: logoColor, range: NSMakeRange(9, 6))
        agreeLabel.attributedText = mutableStr
        
        let registButton = UIButton(frame:CGRect(x:40,y:kmainHeight-280,width:WHITEVIEW_FRAME-80,height:45))
        registButton.setTitle("注册", for: .normal)
        registButton.setTitleColor(logoColor, for: .normal)
        registButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registButton.layer.cornerRadius = registButton.frame.size.height/2
        registButton.layer.borderWidth = 2.0
        registButton.layer.borderColor = logoColor.cgColor
        self.view.addSubview(registButton)
       
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
