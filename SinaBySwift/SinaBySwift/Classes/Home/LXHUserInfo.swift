//
//  LXHUserInfo.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/22.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import SwiftyJSON
class LXHUserInfo: NSObject {
    /// 用户ID
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var avatar_large: String?
    
    /// 用于保存用户头像的URL
    var imageURL: URL?
    
    /// 是否是认证, true是, false不是
    var verified: Bool = false
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1{
        didSet{
            switch verified_type
            {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    /// 保存当前用户的认证图片
    var verifiedImage: UIImage?
    
    /// 会员等级
    var mbrank: Int = 0
    {
        didSet{
            if mbrank > 0 && mbrank < 7
            {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    var mbrankImage: UIImage?
    override init() {
        super.init()
    }
    init(jsonData:JSON) {
        id = jsonData["id"].int!
        name = jsonData["name"].string
        avatar_large = jsonData["avatar_large"].string
        if let urlStr = avatar_large
        {
            imageURL = URL(string: urlStr)
        }
        verified = jsonData["verified"].bool!
        verified_type = jsonData["verified_type"].int!
        mbrank = jsonData["mbrank"].int!
    }
    override var description: String{
        return "\(id) \(name ?? "无名字") \(String(describing: avatar_large)) \(verified) \(verified_type) \(mbrank)"
    }
}
