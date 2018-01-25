//
//  LXHHomeTableViewController.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/9.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

let LXHHomeTabCell = "LXHHomeTabCell"

class LXHHomeTableViewController: LXHBaseTableViewController {
    var titleButton = LXHTitleButton()
    var heightCache:[Int:CGFloat] = [Int:CGFloat]()
    
    var statuses : [LXHStatus]?
    {
        didSet{
            
            tableView.reloadData()
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setVisitorView(isHome: true, imgName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        creatBarButton()
        creatTitleButton()
        if !login {
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name(rawValue: LXHPopoverAnimatorShowNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name(rawValue: LXHPopoverAnimatorDismissNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(load), name: NSNotification.Name(rawValue: startRefresh), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(noti:)), name: NSNotification.Name(rawValue: LXHStatusPictureViewSelected), object: nil)
        
        tableView.register(LXHForwardTableViewCell.self, forCellReuseIdentifier:homeCellIdentifier.forwardCell.rawValue)
        
        tableView.register(LXHNormalTableViewCell.self, forCellReuseIdentifier: homeCellIdentifier.normalCell.rawValue)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        refreshControl = refreshController
    
        refreshController.addTarget(self, action: #selector(load), for: .valueChanged)
//        load()
    }
    let refreshController = LXHHomeRefreshControl()
    
    var pullupRefreshFlag = false
    
    private lazy var newStatusLabel:UILabel = {
        let width = UIScreen.main.bounds.width
        let newStatusLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 44))
        newStatusLabel.textAlignment = NSTextAlignment.center
        newStatusLabel.textColor = UIColor.white
        newStatusLabel.backgroundColor = UIColor.orange
        newStatusLabel.isHidden = true
        self.navigationController?.navigationBar.insertSubview(newStatusLabel, at: 0)
        return newStatusLabel
    }()
    @objc func load(){
        // 1.默认当做下拉处理
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        // 2.判断是否是上拉
        if pullupRefreshFlag
        {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        LXHStatus.loadStatuses(since_id: since_id,max_id:max_id) { (models, error) in
            self.refreshController.endRefreshing()
            if error != nil{
                return
            }
            if since_id>0{
                self.statuses = models! + self.statuses!
                self.showNewStatusCount(count: models?.count ?? 0)
            }else if max_id>0{
                self.statuses = self.statuses! + models!
            }else{
                self.statuses = models
            }
        }
    }
    @objc func showPhotoBrowser(noti:Notification){
        guard let index = noti.userInfo![LXHStatusPictureViewIndexKey] as? IndexPath else {
            return
        }
        guard let urls = noti.userInfo![LXHStatusPictureViewURLsKey] as? [URL] else {
            return
        }
        present(LXHPhotoBrowserViewController.init(index: index, urls: urls), animated: true, completion: nil)
    }
    func showNewStatusCount(count:Int){
        newStatusLabel.isHidden = false
        newStatusLabel.text = "刷新到\(count)条微博"
        UIView.animate(withDuration: 1.25, animations: {
            self.newStatusLabel.transform = CGAffineTransform.init(translationX: 0, y: self.newStatusLabel.frame.size.height)
        }) { (_) in
            UIView.animate(withDuration: 1.25, animations: {
                self.newStatusLabel.transform = CGAffineTransform.identity
                
            }, completion: { (_) in
                self.newStatusLabel.isHidden = true
            })
        }
    }
    
    
    @objc func change(){
        // 修改标题按钮的状态
        let titleBtn = navigationItem.titleView as! LXHTitleButton
        titleBtn.isSelected = !titleBtn.isSelected
    }
    private func creatBarButton(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem(imageName: "navigationbar_friendattention", target: self, action:#selector(leftBarItemClick(btn:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem(imageName: "navigationbar_pop", target: self, action:#selector(rightBarItemClick(btn:)))
    }
    private func creatTitleButton(){
        
        let titleBtn = LXHTitleButton()
        
        titleBtn.setTitle("李小华的微博 ", for: UIControlState.normal)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action:#selector(titleBtnClick(btn:)) , for:.touchUpInside)
        titleButton = titleBtn
        navigationItem.titleView = titleBtn
        
    }
    @objc func titleBtnClick(btn:LXHTitleButton){

        let sb = UIStoryboard.init(name: "LXHPopoverViewController", bundle: nil)
        //创建需要model出来的控制器
        let popover = sb.instantiateInitialViewController()!
        //设置需要model出来的控制的大小
        poperObjc.presentFrame = CGRect.init(x: UIScreen.main.bounds.size.width*0.5-100, y:44 , width: 200, height: 250)
        //设置代理为自定义的一个类：该类遵守UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning 这两个代理并实现其中的方法
        popover.transitioningDelegate = poperObjc
//        popover.transitioningDelegate = self
        //设置model出来的方式为自定义
        popover.modalPresentationStyle = UIModalPresentationStyle.custom
    
        present(popover, animated: true, completion: nil)
    }
    
    @objc func leftBarItemClick(btn:UIBarButtonItem){
       
        self.navigationController!.pushViewController(LXHQRCodeCardViewController(), animated: true)
    }
    @objc func rightBarItemClick(btn:UIBarButtonItem){
        
        let sb = UIStoryboard.init(name: "LXHQRCodeViewController", bundle: nil)
        let nav = sb.instantiateInitialViewController()!
        poperObjc.presentFrame = CGRect.init()
        nav.transitioningDelegate = poperObjc
        nav.modalPresentationStyle = UIModalPresentationStyle.custom
        
        present(nav, animated: true, completion: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
extension LXHHomeTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(statuses?.count as Any)
        return statuses?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier.cellID(status: status), for: indexPath) as! LXHHomeTableViewCell
        cell.status = status
        if indexPath.row == (statuses?.count)!-1 {
            pullupRefreshFlag = true
            load()
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        if let rowHeight = heightCache[status.id] {
            return rowHeight
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier.cellID(status: status)) as! LXHHomeTableViewCell
        let rowHeight = cell.getRowHeight(lxhStatus: status)
        heightCache[status.id] = rowHeight
        
        return rowHeight
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let offy = refreshController.frame.origin.y
        
        if offy>=0{
            return
        }
        if !refreshController.isRefreshing && !refreshController.loadingViewIsRefresh && offy <= -60{
            
            refreshController.beginRefreshing()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: startRefresh), object: nil)
            return
        }
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offy = refreshController.frame.origin.y
        if offy > -60 && refreshController.rotationArrow{//不刷新
            
            refreshController.rotationArrow = false
            refreshController.refreshView.rotationArrowIcon(arrow: refreshController.rotationArrow)
            
        }else if offy <= -60 && !refreshController.rotationArrow{//刷新
            
            refreshController.rotationArrow = true
            refreshController.refreshView.rotationArrowIcon(arrow: refreshController.rotationArrow)
           
        }
    }
}
