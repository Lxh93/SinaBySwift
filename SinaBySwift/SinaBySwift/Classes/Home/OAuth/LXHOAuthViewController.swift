//
//  LXHOAuthViewController.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/14.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

let appkey = "1826634436"
let appSecret = "13d91b940f24db1463a7b03080e7db4d"
let oauthUrl = "https://api.weibo.com/oauth2/authorize?client_id="
let redirect_uri = "http://baidu.com"
var oauthSuccess:String = String()

class LXHOAuthViewController: UIViewController {
    override func loadView() {
        view = oAuthWebView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        oAuthSina()
        addNavBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addNavBarItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back))
    }
    @objc func back(){
        if oAuthWebView.canGoBack{
            oAuthWebView.goBack()
        }
    }
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    func oAuthSina(){
        let urlStr = oauthUrl+appkey+"&redirect_uri="+redirect_uri
        let url = URL(string: urlStr)
        let requset = URLRequest.init(url: url!)
        oAuthWebView.loadRequest(requset)
        
    }
    
    private lazy var oAuthWebView:UIWebView = {
       let web = UIWebView()
        web.scalesPageToFit = true
        web.delegate = self
        return web
    }()
    
}
extension LXHOAuthViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{

        if request.url?.query != nil {
            if (request.url!.absoluteString.hasPrefix(redirect_uri)){
                if (request.url?.query?.hasPrefix("code="))! {
                    
                    let codeStr = request.url!.query!
                    let codeStrIndex = codeStr.index(after: "code".endIndex)
                    
                    oauthSuccess = String(codeStr[codeStrIndex...])
                    
                    oauthSuc {
//                        self.close()
                        
                        NotificationCenter.default.post(name: NSNotification.Name.init(LXHSwitchRootViewControllerKey), object: true)
                    }
                    
                }else{
                    close()
                }
                return false
            }
        }
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "loading...")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        SVProgressHUD.showInfo(withStatus: "load fail")
//        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    func oauthSuc(finished:@escaping()->()){
        
        let oauthSucUrl = "https://api.weibo.com/oauth2/access_token?client_id="+appkey+"&client_secret="+appSecret+"&grant_type=authorization_code"+"&code="+oauthSuccess+"&redirect_uri="+redirect_uri
        let url = URL.init(string: oauthSucUrl)
    
        Alamofire.request(url!, method: .post).responseJSON { (needJson:DataResponse) in
            //            "access_token" = "2.00mpnGkGkD4czBdf832415d7xO8jIE";
            //            "expires_in" = 157679999;
            //            isRealName = true;
            //            "remind_in" = 157679999;
            //            uid = 6178129982;
            // 1.字典转模型
            /*
             plist : 特点只能存储系统自带的数据类型
             将对象转换为json之后写入文件中 --> 在公司中已经开始使用
             偏好设置: 本质plist
             归档 : 可以存储自定义对象
             数据库: 用于存储大数据 , 特点效率较高
             */
            if needJson.result.isFailure{
                return
            }else{
                if needJson.error != nil{
                    return
                }
            }
            let json = JSON(needJson.data as Any)
            let loginAccount = LXHLoginAccount.init(jsonData: json)
            
            loginAccount.loadUserInfo(finished: { (account, error) in
                if account != nil{
                    account?.saveUserAccount()
                }
                finished()
            })
            
            
        }
        
    }
}

