//
//  LXHHomeCellTopView.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/25.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHHomeCellTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    var status = LXHStatus(){
        didSet{
            if let url = status.user.imageURL {
                iconView.sd_setImage(with: url, completed:nil)
            }
            verifiedView.image = status.user.verifiedImage
            nameLabel.text = status.user.name
            vipView.image = status.user.mbrankImage
            timeLabel.text = status.created_at
            sourceLabel.text = status.source
        }
    }
    
    func setupUI(){
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2.布局子控件
        
        let _ =  iconView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: margin, y: margin))
        let _ = verifiedView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        let _ = nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: iconView, size: nil, offset: CGPoint(x: margin, y: 0))
        let _ =  vipView.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: margin, y: 0))
        let _ = timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: iconView, size: nil, offset: CGPoint(x: margin, y: 0))
        let _ = sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: margin, y: 0))
    }
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView =
    {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(color: UIColor.darkGray, fontSize: 14)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
