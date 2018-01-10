//
//  LXHPopoverViewController.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/12.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHPopoverViewController: UIPresentationController {
    var presentFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        containerView?.insertSubview(coverView, at: 0)
        coverView.frame = containerView!.frame
        if presentFrame == CGRect.init(x: 0, y: 0, width: 0, height: 0){
            presentedView?.frame = UIScreen.main.bounds
        }else{
            presentedView?.frame = presentFrame
        }
        
    }
    
    private lazy var coverView:UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeCover))
        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    @objc func closeCover(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
