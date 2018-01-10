//
//  LXHWelcomeViewController.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/16.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import SDWebImage
class LXHWelcomeViewController: UIViewController {
    var bottomCons:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImgView)
        view.addSubview(iconImgView)
        view.addSubview(messageLabel)
        let _ = messageLabel.xmg_AlignVertical(type: XMG_AlignType.bottomCenter, referView: iconImgView, size: nil, offset: CGPoint.init(x: 0, y: 20))
        let cons = iconImgView.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: bgImgView, size: CGSize.init(width: 100, height: 100), offset: CGPoint.init(x: 0, y: -140))
        bottomCons = iconImgView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.bottom)
        if let urlStr = LXHLoginAccount.loadUserAccount()?.avatar_large {
            iconImgView.sd_setImage(with: URL.init(string: urlStr), completed: nil)
        }
        if let name = LXHLoginAccount.loadUserAccount()?.screen_name {
            messageLabel.text = "欢迎回来,\(name)"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        welcomeAnimation()
    }
    lazy var bgImgView:UIImageView = {
        let imgView = UIImageView.init(frame: UIScreen.main.bounds)
        imgView.image = UIImage.init(named: "ad_background")
        
        return imgView
    }()
    lazy var iconImgView:UIImageView = {
       let imgView = UIImageView.init(image: UIImage.init(named: "avatar_default_big"))
        imgView.layer.cornerRadius = 50
        imgView.clipsToBounds = true
        return imgView
    }()
    lazy var messageLabel:UILabel = {
       let msgLabel = UILabel.init()
        msgLabel.text = "欢迎回来"
        msgLabel.textColor = UIColor.darkGray
        msgLabel.textAlignment = NSTextAlignment.center
        msgLabel.alpha = 0
        return msgLabel
    }()
    func welcomeAnimation(){

        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .layoutSubviews, animations: {
            self.bottomCons!.constant = -UIScreen.main.bounds.size.height - self.bottomCons!.constant

            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.5, animations: {
                self.messageLabel.alpha = 1
            }, completion: { (_) in
                //本界面本身就是欢迎界面 所以传值为false
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: LXHSwitchRootViewControllerKey), object: false)
            })
        }
    }
}
