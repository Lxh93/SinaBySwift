//
//  LXHVisitorView.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/11.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
protocol LXHVisitorViewDelegate:NSObjectProtocol{
    func visitorViewLogin()
    func visitorViewRegister()
}
class LXHVisitorView: UIView {

    weak var delegate: LXHVisitorViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setVisitorView(isHome:Bool,imgName:String,message:String) -> () {
        smalliconImage.isHidden = !isHome
        messageLabel.text = message
        houseImage.image = UIImage(named:imgName)
        if isHome {
            startAnimation()
        }
    }
    private func setUI()
    {
        
        addSubview(smalliconImage)
        addSubview(maskIconView)
        addSubview(houseImage)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        
        let _ = smalliconImage.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: nil, offset: CGPoint.zero)
        let _ = maskIconView.xmg_Fill(referView: self, insets: UIEdgeInsetsMake(0, 0, 44, 0))
        let _ = houseImage.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: nil, offset: CGPoint.zero)
        let _ = messageLabel.xmg_AlignVertical(type: XMG_AlignType.bottomCenter, referView: smalliconImage, size: nil, offset: CGPoint.zero)
        let _ = addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 224))
        let _ = registerButton.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: messageLabel, size: CGSize.init(width: 100, height: 35), offset: CGPoint.init(x: 0, y: 20))
        let _ = loginButton.xmg_AlignVertical(type: XMG_AlignType.bottomRight, referView: messageLabel, size: CGSize.init(width: 100, height: 35), offset: CGPoint.init(x: 0, y: 20))
    }
    private lazy var smalliconImage:UIImageView = {
        
        let imgView = UIImageView.init(image:UIImage(named:"visitordiscover_feed_image_smallicon"))
        
        return imgView
    }()
    private lazy var maskIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return iv
    }()
    private lazy var houseImage:UIImageView = {
        
        let imgView = UIImageView.init(image:UIImage(named:"visitordiscover_feed_image_house"))
        
        return imgView
    }()
    /// 消息文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        // 注册监听
        btn.addTarget(self, action: #selector(registerBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        // 注册监听
        btn.addTarget(self, action: #selector(loginBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    @objc func registerBtnClick()
    {
        // OC 中需要 isResponse
        delegate?.visitorViewRegister()
        
    }
    @objc func loginBtnClick()
    {
        delegate?.visitorViewLogin()
        
    }
    private func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 15
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        smalliconImage.layer.add(anim, forKey: nil)
        }
}
