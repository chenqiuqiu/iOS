//
//  HomeViewController.swift
//  User.Swift
//
//  Created by 陈彦彤 on 17/7/9.
//  Copyright © 2017年 陈彦彤. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var redView : UIView?
    let tapView = UIView()
    var currentVC : UIViewController?
    var locationVC = LocationViewController()
    let regionVC = RegionViewController()
    let traceVC = TraceViewController()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = logoColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
       
        self.navigationItem.rightBarButtonItem?.title = "侧滑栏"
        self.navigationItem.leftBarButtonItem?.title = "报警"
        self.cotrollersInit()
        
        self.tapViewInit()
    }

    func tapViewInit() {
        
        tapView.frame = CGRect(x:0,y:0,width:kmainWidth,height:40)
        tapView.backgroundColor = UIColor.white
        tapView.layer.shadowColor = UIColor.lightGray.cgColor
        tapView.layer.shadowOffset = CGSize(width:2,height:2)
        tapView.layer.shadowRadius = 3
        tapView.layer.shadowOpacity = 0.8
        self.view.addSubview(tapView)
        
        let titleArr : NSArray = ["定位","电子围栏","轨迹"]
        
        for index in 0..<3 {
            let tapButton = UIButton(frame:CGRect(x:20+105*index,y:0,width:85,height:38))
            //tapButton.backgroundColor = UIColor.red
            tapButton.setTitle(String(describing: titleArr[index]), for: .normal)
            tapButton.setTitleColor(logoColor, for: .normal)
            tapButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            tapButton.tag = 100+index
            tapButton.addTarget(self, action: #selector(changeContrlAction(sender:)), for: .touchUpInside)
            tapView.addSubview(tapButton)
            
        }
        redView = UIView(frame:CGRect(x:0,y:38.5,width:(kmainWidth-64)/3,height:1.5))
        redView?.backgroundColor = logoColor
        tapView.addSubview(redView!)
        
    }
       
    
    func cotrollersInit() {
        locationVC.view.frame = CGRect(x:0,y:36,width:kmainWidth,height:kmainHeight-100)
        self.addChildViewController(locationVC)
        
        regionVC.view.frame = locationVC.view.frame
        self.addChildViewController(regionVC)
        
        traceVC.view.frame = regionVC.view.frame
        self.addChildViewController(traceVC)
        currentVC = UIViewController()
        currentVC = locationVC
        self.view.addSubview(currentVC!.view)
    }
    func changeContrlAction(sender:UIButton) {
        switch sender.tag {
        case 100:
            self.replaceController(oldController:currentVC!, newController:locationVC)
            currentVC! = locationVC
        case 101:
            self.replaceController(oldController: currentVC!, newController: regionVC)
            currentVC! = regionVC
        default:
            self.replaceController(oldController: currentVC!, newController: traceVC)
            currentVC! = traceVC
        }
        
        let redViewWidth = Double ((kmainWidth-64)/3+10)
        let index = Double (sender.tag-100)
        
        UIView.animate(withDuration: 0.3) { 
            self.redView?.frame = CGRect(x:redViewWidth * index,y:38.5,width:Double((kmainWidth-64)/3),height:1.5)
        }
    }
    
    
    
    
    
    
    
    
    
    //子控制器转换
    func replaceController(oldController:UIViewController,newController:UIViewController){
        self.addChildViewController(newController)
        newController.didMove(toParentViewController: self)
        self.view.insertSubview(newController.view, belowSubview: tapView)
        oldController.willMove(toParentViewController: nil)
        oldController.removeFromParentViewController()
        self.currentVC = newController
      
       
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
