//
//  LXHForwardTableViewCell.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/27.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHForwardTableViewCell: LXHHomeTableViewCell {

    override func setupUI() {
        super.setupUI()
        initUI()
    }
    // 重写父类属性的didSet并不会覆盖父类的操作
    // 只需要在重写方法中, 做自己想做的事即可
    // 注意点: 如果父类是didSet, 那么子类重写也只能重写didSet
    override var status: LXHStatus
        {
        didSet{
            let name = status.retweeted_status?.user.name ?? ""
            let text = status.retweeted_status?.text ?? ""
            forwardLabel.text = "@" + name + ": " + text
        }
    }
    func initUI(){
        
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        let _ = forwardButton.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: nil, offset: CGPoint.init(x: -10, y: 10))
        
        let _ = forwardButton.xmg_AlignVertical(type: XMG_AlignType.topRight, referView: footerView, size: nil, offset: CGPoint.zero)
        
        let _ = forwardLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: forwardButton, size: nil, offset: CGPoint.init(x: 10, y: 10))
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: forwardLabel, size: CGSize.init(width: width-2*margin, height: 1), offset: CGPoint(x: 0, y: margin))
        
        pictureWidthCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons =  pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.height)
        pictureTopCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.top)
        
    }
    lazy var forwardLabel:UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.text = "shushdsjdhaijbdfajbdfjabfjdfhajofdhnaojkhfdaikjf"
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width-2*margin
        return label
    }()
    lazy var forwardButton:UIButton = {
        let button = UIButton.init(type: UIButtonType.custom)
//        button.backgroundColor = UIColor.green
        button.setBackgroundImage(UIImage.init(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        return button
    }()
}
