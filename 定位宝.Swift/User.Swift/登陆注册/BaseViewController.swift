//
//  BaseViewController.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/7/7.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    let imageView = UIImageView()
    let loginVC = LoginViewController()
    let registVC = RegistViewController()
    var currentVC = UIViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white
        imageView.image = UIImage(named:"WechatIMG108.png")
        imageView.frame = UIScreen.main.bounds
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        self.initControllers()
        self.changeButtonsInit()
    }
    //初始化子视图
    func initControllers(){
        loginVC.view.frame = CGRect(x:35,y:85,width:kmainWidth-70,height:kmainHeight*0.62)
        loginVC.view.layer.cornerRadius = 12;
        loginVC.view.backgroundColor = UIColor.white.withAlphaComponent(0.72)
        self.addChildViewController(loginVC);
        imageView.addSubview(loginVC.view);
        
        registVC.view.frame = CGRect(x:25,y:70,width:kmainWidth-50,height:kmainHeight*0.7)
        registVC.view.layer.cornerRadius = 12;
        self.addChildViewController(registVC);
        imageView.addSubview(loginVC.view);
        
        currentVC = loginVC;
    }
    
    func changeButtonsInit() {
        let btnTitleArr:Array = ["注册账号","忘记密码？"]
        
        for i in 0...1 {
            let originX = kmainWidth/4-50
            let distance = CGFloat(i) * kmainWidth/2
            let changeButton = UIButton(frame:CGRect(x:originX+distance,y:kmainHeight-70,width:100,height:30))
            changeButton.setTitle(btnTitleArr[i], for: UIControlState.normal)
            changeButton.setTitleColor(UIColor.white,for: .normal)
            changeButton.titleLabel?.textAlignment = NSTextAlignment.center
            changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            changeButton.addTarget(self, action:#selector(changeAction(sender:)), for: UIControlEvents.touchUpInside)
            changeButton.tag = 100+i
            self.view.addSubview(changeButton)
            
            
        }
        let line = UIView(frame:CGRect(x:kmainWidth/2,y:kmainHeight-60,width:1.5,height:20))
        line.backgroundColor = UIColor.white
        self.view.addSubview(line)
    
    }
    
    
    func changeAction(sender:UIButton) {
        if sender.tag == 100 && currentVC != registVC {
            self.replaceController(oldController: currentVC, newController: registVC)
        }else{
            
        }
    }
    
    
    //子控制器转换
    func replaceController(oldController:UIViewController,newController:UIViewController){
        self.addChildViewController(newController)
        self.transition(from: oldController, to: newController, duration: 0.4, options: .transitionFlipFromRight, animations:nil,completion: {(finished)->Void in
            
            newController.didMove(toParentViewController: self)
            self.view.addSubview(newController.view)
            oldController.willMove(toParentViewController: nil)
            oldController.removeFromParentViewController()
            self.currentVC = newController
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
