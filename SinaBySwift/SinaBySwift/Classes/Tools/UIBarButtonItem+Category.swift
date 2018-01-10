//
//  UIBarButtonItem+Category.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/12.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    class func creatBarButtonItem(imageName:String,target:Any,action:Selector)->UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named:imageName+"_highlighted"), for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: btn)
        return barButton
    }
}
