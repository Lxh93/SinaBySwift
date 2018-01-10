//
//  LXHHomeRefreshControl.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/27.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

let startRefresh = "startRefresh"

class LXHHomeRefreshControl: UIRefreshControl {
    
    override init() {
        super.init()
        
        setupUI()
    }
    func setupUI(){
        addSubview(refreshView)
        let _ = refreshView.xmg_Fill(referView: self, insets: UIEdgeInsets.zero)
        
    }
    var rotationArrow = false
    var loadingViewIsRefresh = false
    
    override func beginRefreshing() {
        super.beginRefreshing()
        
        refreshView.startRefreshIng()
        loadingViewIsRefresh = true
    }
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopRefresh()
        loadingViewIsRefresh = false
    }
    lazy var refreshView:HomerefreshView = HomerefreshView.refreshView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
class HomerefreshView:UIView{
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var loadingView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    func rotationArrowIcon(arrow:Bool){
        tipLabel.text = arrow ?"松手刷新...":"下拉刷新..."
        var angle = CGFloat.pi
        angle += arrow ? -0.01:0.01
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowIcon.transform = self.arrowIcon.transform.rotated(by: angle)
            
        }) { (_) in
            
        }
        
    }
    func startRefreshIng(){
        
        tipView.isHidden = true
        let anim = CABasicAnimation.init(keyPath: "transform.rotation")
        anim.toValue = 2*Double.pi
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        loadingView.layer.add(anim, forKey: nil)
    }
    
    func stopRefresh(){
        tipView.isHidden = false
        loadingView.layer.removeAllAnimations()
    }
    class func refreshView()->HomerefreshView {
        
        return Bundle.main.loadNibNamed("LXHHomeRefreshView", owner: nil, options: nil)?.last as! HomerefreshView
    }
}
extension LXHHomeRefreshControl:UIScrollViewDelegate{
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let offy = frame.origin.y
        
        if offy>=0{
            return
        }
        if !isRefreshing && !loadingViewIsRefresh && offy <= -60{
            
            beginRefreshing()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: startRefresh), object: nil)
            return
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offy = frame.origin.y
        if offy > -60 && rotationArrow{//不刷新
           
            rotationArrow = false
            refreshView.rotationArrowIcon(arrow: rotationArrow)
            
        }else if offy <= -60 && !rotationArrow{//刷新
            
            rotationArrow = true
            refreshView.rotationArrowIcon(arrow: rotationArrow)
            
            
        }
    }
}
