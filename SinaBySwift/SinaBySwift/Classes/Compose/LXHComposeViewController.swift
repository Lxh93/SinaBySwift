//
//  LXHComposeViewController.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2018/1/3.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LXHComposeViewController: UIViewController {
    
    
    var toolBarConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameHasChange(notify:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        view.backgroundColor = UIColor.white
        setupNav()
        setutInputView()
        setupToolBar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /// 初始化导航栏
    private func setupNav(){
        let closeBtn = UIBarButtonItem.init(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeBtnClick))
        let sendBtn = UIBarButtonItem.init(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendBtnClick))
        
        navigationItem.leftBarButtonItem = closeBtn
        navigationItem.rightBarButtonItem = sendBtn
        navigationItem.rightBarButtonItem?.isEnabled = false
        // 3.添加中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel()
        label1.text = "发送微博"
        label1.font = UIFont.systemFont(ofSize: 15)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = LXHLoginAccount.loadUserAccount()?.screen_name
        label2.font = UIFont.systemFont(ofSize: 13)
        label2.textColor = UIColor.darkGray
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        let _ = label1.xmg_AlignInner(type: XMG_AlignType.topCenter, referView: titleView, size: nil, offset: CGPoint.zero)
        let _ = label2.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: titleView, size: nil, offset: CGPoint.zero)
        
        navigationItem.titleView = titleView
    }
    ///设置输入视图
    private func setutInputView(){
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        let _ = textView.xmg_Fill(referView: view, insets: UIEdgeInsets.zero)
        let _ = placeholderLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: textView, size: nil, offset: CGPoint.init(x: 5, y: 7.5))
    }
    private func setupToolBar(){
        view.addSubview(toolBar)
        let cons = toolBar.xmg_AlignInner(type: XMG_AlignType.bottomLeft, referView: view, size: CGSize.init(width: sBounds.width, height: 44), offset: CGPoint.zero)
        toolBarConstraint = toolBar.xmg_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.bottom)!
    }
    /// 文本框
    private lazy var textView:UITextView = {
        let tV = UITextView()
        tV.font = UIFont.systemFont(ofSize: 17)
        tV.delegate = self
        return tV
    }()
    
    /// 提示文本
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = textView.font
        label.textColor = UIColor.darkGray
        label.text = "分享新鲜事..."
        return label
    }()
    
    @objc func keyboardFrameHasChange(notify:Notification){
        
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.cgRectValue
        toolBarConstraint?.constant = -(sBounds.size.height - rect.origin.y)
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        UIView.animate(withDuration: duration.doubleValue, animations: {
            
            self.view.layoutIfNeeded()
        })
        
    }
    private lazy var toolBar:UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGray
        
        var items = [UIBarButtonItem]()
        
        let itemImages = ["compose_toolbar_picture","compose_mentionbutton_background","compose_trendbutton_background","compose_emoticonbutton_background","compose_addbutton_background"]
        
        for i in 0..<itemImages.count{
            let item = UIBarButtonItem.creatBarButtonItem(imageName: itemImages[i], target: self, action: #selector(selectPicture))
            items.append(item)
            items.append(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
            
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    /**
     选择相片
     */
    @objc func selectPicture()
    {
        
    }
    /**
     切换表情键盘
     */
    @objc func inputEmoticon()
    {
        
    }
    /// 关闭当前界面
    @objc func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    
    /// 发送微博数据
    @objc func sendBtnClick(){
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json?access_token=\(LXHLoginAccount.loadUserAccount()?.access_token ?? "lxh")&status=\(textView.text!)"
        Alamofire.request(urlStr, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            switch response.result {
                
            case .success(_):
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                SVProgressHUD.dismiss(withDelay: 1.5)
                self.closeBtnClick()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "发送失败")
                SVProgressHUD.dismiss(withDelay: 1.5)
                print(error)
            }
        }
    }
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
extension LXHComposeViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}

