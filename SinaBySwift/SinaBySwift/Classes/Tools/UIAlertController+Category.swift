//
//  UIAlertController+Category.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/13.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
extension UIAlertController{
    class func showInfoInAlert(message:String){
        let alert = UIAlertController.init(title: "温馨提示", message:message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { _ in
            //            self.dismiss(animated: true, completion: nil)
        }
        alert .addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    class func showInfoInAlert(controller:UIViewController,message:String){
        let alert = UIAlertController.init(title: "温馨提示", message:message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { _ in
            //            self.dismiss(animated: true, completion: nil)
        }
        alert .addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
