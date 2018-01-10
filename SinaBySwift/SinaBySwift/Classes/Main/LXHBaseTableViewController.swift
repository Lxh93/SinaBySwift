//
//  LXHBaseTableViewController.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/11.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit



class LXHBaseTableViewController: UITableViewController {
    var login:Bool = LXHLoginAccount.userLogin()
    var visitorView = LXHVisitorView()
    
    override func loadView()
    {
        login ? super.loadView():setVisitorView()
        
    }
    private func setVisitorView()
    {
        visitorView = LXHVisitorView()
        visitorView.delegate = self
        view = visitorView
    }
    public func showInfoInAlert(message:String){

        let alert = UIAlertController.init(title: "温馨提示", message:message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { _ in
        //            self.dismiss(animated: true, completion: nil)
        }
        alert .addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    lazy var poperObjc:LXHPopoverAnimator = LXHPopoverAnimator()
}
extension LXHBaseTableViewController:LXHVisitorViewDelegate
{
    func visitorViewRegister() {
        
        showInfoInAlert(message: "创建注册界面")
    }
    func visitorViewLogin() {
//        showInfoInAlert(message: "创建登录界面")
        let ovc = LXHOAuthViewController()
        let nav = UINavigationController.init(rootViewController: ovc)
        ovc.modalPresentationStyle = .custom
        ovc.transitioningDelegate = poperObjc
        present(nav, animated: true, completion: nil)
        
    }
    
}
