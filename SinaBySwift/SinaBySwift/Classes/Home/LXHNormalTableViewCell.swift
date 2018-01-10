//
//  LXHNormalTableViewCell.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/27.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHNormalTableViewCell: LXHHomeTableViewCell {

    override func setupUI() {
        super.setupUI()
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: CGSize.init(width: width-2*margin, height: 1), offset: CGPoint(x: 0, y: margin))
        
        pictureWidthCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons =  pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.height)
        pictureTopCons = pictureView.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.top)
    }

}
