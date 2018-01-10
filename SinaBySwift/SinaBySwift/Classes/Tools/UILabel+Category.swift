//
//  UILabel+Category.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/19.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
extension UILabel{
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
}
