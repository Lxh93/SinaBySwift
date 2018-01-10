//
//  LXHMainViewController.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/9.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

    class LXHMainViewController: UITabBarController {

        override func viewDidLoad() {
            super.viewDidLoad()
            addChildControllers()
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let compose = addCompose
            tabBar.addSubview(compose)
        }
        private lazy var addCompose:UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .normal)
            button.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: .highlighted)
            button.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: .normal)
            button.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: .highlighted)
            button.addTarget(self, action: #selector(composeClick(button:)), for: UIControlEvents.touchUpInside)
            let width = UIScreen.main.bounds.size.width/CGFloat(viewControllers!.count)
            let height:CGFloat = 44
            let rect = CGRect(x: CGFloat(0), y:CGFloat(2), width:width, height: height)
            button.frame = rect.offsetBy(dx: width*2, dy: 0)
            return button
        }()
        @objc func composeClick(button:UIButton)->(){
            
            let composeVC = LXHComposeViewController()
            
            let nav = UINavigationController.init(rootViewController: composeVC)
            
            present(nav, animated: true, completion: nil)
        }
        /// 初始化子控制器
        ///
        /// - Parameters:
        ///   - childController: 子控制器
        ///   - title: 子控制器标题
        ///   - imageName: 子控制器图片名字
        private func addChildControllers(){
            //设置当前tabbar对应的颜色
//            tabBar.tintColor = UIColor.orange
            
            let path = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)
            let jsonData = NSData(contentsOfFile:path!)
            do {
                let jsonArr = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                for vcDic in jsonArr as! [[String:String]] {
                    addChildController(childControllerNamed: vcDic["vcName"]!, title: vcDic["title"]!, imageName: vcDic["imageName"]!)
                }
            } catch{
                print(error)
                addChildController(childControllerNamed:"LXHHomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildController(childControllerNamed: "LXHMessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildController(childControllerNamed: "NullViewController", title: "", imageName: "")
                addChildController(childControllerNamed: "LXHDiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
                addChildController(childControllerNamed: "LXHProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }
        private func addChildController(childControllerNamed: String,title:String,imageName:String) {
    //        <Sina__Swift.LXHHomeTableViewController: 0x7fac23e082d0>
            let named = Bundle.main.infoDictionary!["CFBundleName"] as! String
            
            let cls:AnyClass? = NSClassFromString(named + "." + childControllerNamed)
            let vcCls = cls as! UIViewController.Type
            let vc = vcCls.init()
            
            //1.设置tabbarItem
            vc.tabBarItem.image = UIImage(named:imageName)
            vc.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")
            vc.title = title
            //2.定制一个导航控制器
            let nav = UINavigationController()
            nav.addChildViewController(vc)
            
            addChildViewController(nav)
        }

    }
