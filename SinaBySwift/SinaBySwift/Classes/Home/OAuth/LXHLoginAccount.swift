//
//  LXHLoginAccount.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/16.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import SwiftyJSON
import Alamofire
class LXHLoginAccount :NSObject,NSCoding{
    
    /// 拿到的授权信息
    var access_token:String?
    /// 是否是真实姓名
    var isRealName:String?
    /// 用户uid
    var uid:String?
    /// 授权过期时间（日期）
    var expires_date:String?
    /// 授权过期时间（秒数）
    var expires_in:NSNumber?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?
    
    ///json转模型
    init(jsonData: JSON) {
        access_token    = jsonData["access_token"].string
        isRealName = jsonData["isRealName"].string
        uid = jsonData["uid"].string
        expires_in = jsonData["expires_in"].number
        let date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        expires_date = formatter.string(from: date as Date)
        
    }
    static var userAccount:LXHLoginAccount?
    ///对授权信息进行归档
    func saveUserAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile:"account.plist".cacheDir())
    }
    ///获取用户基本信息
    func loadUserInfo(finished:@escaping (LXHLoginAccount?,Error?)->()){
        
        let url = "https://api.weibo.com/2/users/show.json?access_token=\(access_token!)&uid=\(uid!)"
        
        
        let parameters = ["access_token":"2.00mpnGkGkD4czBdf832415d7xO8jIE","uid":"6178129982"] as Parameters
       
        Alamofire.request(url, method: HTTPMethod.get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (needJSON:DataResponse) in
            
            if needJSON.result.isFailure {
                finished(nil, needJSON.error)
                return
            }
            if needJSON.error == nil{
                let userDic = JSON(needJSON.data as Any)
                self.screen_name = userDic["screen_name"].string
                self.avatar_large = userDic["avatar_large"].string
                
                finished(self, nil)
            }else{
                finished(nil, needJSON.error)
            }
        }
        
    }
    
    ///解档本地授权信息
    class func loadUserAccount()->LXHLoginAccount? {
        if userAccount != nil {
            return userAccount!
        }
        userAccount = (NSKeyedUnarchiver.unarchiveObject(withFile: "account.plist".cacheDir()) as? LXHLoginAccount)
        
        return userAccount
    }
    ///返回用户是否已经提供授权判断是否已登录
    class func userLogin()->Bool {
        return loadUserAccount() != nil
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key,value as Any)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(isRealName, forKey: "isRealName")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    override var description: String{
        // 1.定义属性数组
//        let properties = ["access_token", "expires_in", "uid", "expires_date", "avatar_large", "screen_name"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  ["access_token":access_token as Any,"expires_in":expires_in as Any,"uid":uid as Any,"expires_date":expires_date as Any,"avatar_large":avatar_large as Any,"screen_name":screen_name as Any,"isRealName":isRealName as Any] as [String : Any]
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = (aDecoder.decodeObject(forKey: "expires_in") as? NSNumber)
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? String
        isRealName = aDecoder.decodeObject(forKey: "isRealName") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    
}
