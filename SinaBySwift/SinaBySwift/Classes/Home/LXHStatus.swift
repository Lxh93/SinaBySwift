//
//  LXHStatus.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/22.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
class LXHStatus: NSObject {
    
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls:[PicObj]?
    {
        
        didSet{
            print("didSet")
        }
        willSet{
            print("willSet")
        }
    }
    var user = LXHUserInfo()
    
    /// 保存当前微博所有配图的URL
    var storedPicURLS = [URL]()
    /// 保存当前微博所有配图"大图"的URL
    var storedLargePicURLS: [URL]?
    /// 转发微博
    var retweeted_status:LXHStatus?
    // 如果有转发, 原创就没有配图
    /// 定义一个计算属性, 用于返回原创获取转发配图的URL数组
    var pictureURLS:[URL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedPicURLS : storedPicURLS
    }
    /// 定义一个计算属性, 用于返回原创或者转发配图的大图URL数组
    var LargePictureURLS:[URL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLS : storedLargePicURLS
    }
    init(jsonData:JSON) {
        
        let create_time = jsonData["created_at"].stringValue
        // 1.将字符串转换为时间
        let createdDate = Date.dateWithStr(time: create_time)
        // 2.获取格式化之后的时间字符串
        created_at = createdDate.descDate
        
        id = jsonData["id"].intValue
        text = jsonData["text"].stringValue
        let sourceStr = jsonData["source"].stringValue
        // 1.截取字符串
        
        if sourceStr == ""
        {
            return
        }
        // 1.1获取开始截取的位置
        let startLocation = (sourceStr as NSString).range(of: ">").location + 1
        // 1.2获取截取的长度
//        NSString.CompareOptionsNSString.CompareOptions.BackwardsSearch
        let length = (sourceStr as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startLocation
        // 1.3截取字符串
        source = "来自:" + (sourceStr as NSString).substring(with: NSMakeRange(startLocation, length))
        
        pic_urls = PicObj.dicts2PicObj(list: jsonData["pic_urls"].arrayValue)
        user = LXHUserInfo.init(jsonData: jsonData["user"])
        // 1.初始化数组
        storedPicURLS = [URL]()
        storedLargePicURLS = [URL]()
        
        // 2遍历取出所有的图片路径字符串
        for dict in pic_urls!
        {
            if let urlStr = dict.thumbnail_pic
            {
                // 1.将字符串转换为URL保存到数组中
                storedPicURLS.append(URL(string: urlStr)!)
                
                // 2.处理大图
                let largeURLStr = urlStr.replacingOccurrences(of: "thumbnail", with: "large")
                //                    stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                storedLargePicURLS!.append(URL(string: largeURLStr)!)
                
            }
        }
        
        
        if jsonData["retweeted_status"] != JSON.null {
            
            retweeted_status = LXHStatus.init(jsonData: jsonData["retweeted_status"])
        }
    }
    override init() {
        super.init()
    }
    class func loadStatuses(since_id: Int, max_id: Int ,finished:@escaping (_ statuses:[LXHStatus]?,_ error:Error?)->Void){
        let since = "https://api.weibo.com/2/statuses/home_timeline.json?access_token="+(LXHLoginAccount.loadUserAccount()?.access_token)!+"&since_id=\(since_id)"
        
        let max = "https://api.weibo.com/2/statuses/home_timeline.json?access_token="+(LXHLoginAccount.loadUserAccount()?.access_token)!+"&max_id=\(max_id > 0 ? max_id - 1:max_id)"
        
        let urlStr = since_id > 0 ? since : max
        
        Alamofire.request(urlStr, method: HTTPMethod.get, parameters: nil, encoding:JSONEncoding.default , headers: nil).responseJSON { (respon) in
//            print(respon)
            switch respon.result{
                case .success(let value):
                    
                    let json = JSON(value as Any)
                    
                    let models = dicts2LXHStatus(list: json["statuses"].arrayValue)
                    
                    cacheStatusImages(list: models!, finished: finished)
                case .failure(let error):
                    finished(nil, error)
                print(error)
            }
        }
    }
    class func dicts2LXHStatus(list:[JSON])->[LXHStatus]?{
        var models = [LXHStatus]()
        for status in list {
            
            let newStatus = LXHStatus.init(jsonData: status)
            
            models.append(newStatus)
        }
        return models
    }
    class func cacheStatusImages(list:[LXHStatus],finished:@escaping (_ status:[LXHStatus]?,_ error:Error?)->())
    {
        // 1.创建一个组
        let group = DispatchGroup.init()
        for status in list{
            guard status.pictureURLS?.first != nil else
            {
                continue
            }
            for url in status.pictureURLS!{
                // 将当前的下载操作添加到组中
//                dispatch_group_enter(group) 已废弃
                group.enter()
                
//                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil, completed: { (image, _, _, _) in
//
//                    group.leave()
//                })
                
                SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.init(rawValue: 0), progress: nil, completed: { (_, _, _, _, _, _) in
                    group.leave()
                })
            }
        }
        group.notify(queue: .main) {
            finished(list, nil)
        }
        
    }
    override var description: String{
        let des = "created_at = \(created_at!) id = \(id) text = \(text!) source = \(source!) pic_urls = \(pic_urls)"
        
        // 3.将字典转换为字符串
        return des
    }
}
class PicObj:NSObject {
    var thumbnail_pic:String?
    override init() {
        super.init()
    }
    init(jsonData:JSON) {
        thumbnail_pic = jsonData["thumbnail_pic"].stringValue
    }
    class func dicts2PicObj(list:[JSON])->[PicObj]{
        var models = [PicObj]()
        for picObj in list {
            let newPicObj = PicObj.init(jsonData: picObj)
            
            models.append(newPicObj)
        }
        return models
    }
    override var description: String{
        return "thumbnail_pic = \(thumbnail_pic!)\n"
    }
}
