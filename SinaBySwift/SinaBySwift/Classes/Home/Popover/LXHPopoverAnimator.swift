//
//  LXHPopoverAnimator.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/12.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
let LXHPopoverAnimatorShowNotification = "LXHPopoverAnimatorShowNotification"
let LXHPopoverAnimatorDismissNotification = "LXHPopoverAnimatorDismissNotification"

class LXHPopoverAnimator: NSObject {
    var presentFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    var isPresent = false
    
}
extension LXHPopoverAnimator:UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    ///返回负责转场的控制器
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let pc = LXHPopoverViewController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        //model出一个控制器时
        isPresent = true

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LXHPopoverAnimatorShowNotification), object: nil)
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        //dismiss一个控制器时
        isPresent = false

        NotificationCenter.default.post(name: NSNotification.Name(rawValue:LXHPopoverAnimatorDismissNotification) , object: nil)
        return self
    }
    
    //返回转场动画的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //自定义转场动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            transitionContext.containerView.addSubview(toView!)
            toView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.000001)
            /*锚点 -------- x = 1
                  |
                  |
                  |
                y = 1
            */
            toView?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
            
        }else{
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.000001)
            }, completion: { (_) in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            
        }
    }
    
    
}
