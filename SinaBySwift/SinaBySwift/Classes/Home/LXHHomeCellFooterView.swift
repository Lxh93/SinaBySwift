//
//  LXHHomeCellFooterView.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/25.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

/// 自定义底部视图
class LXHHomeCellFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    func setupUI() {
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        let _ = xmg_HorizontalTile(views: [retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets.zero)
        
    }
    
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_retweet", title: "转发")
    
    // 赞
    private lazy var unlikeBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_unlike", title: "赞")
    
    // 评论
    private lazy var commonBtn: UIButton = UIButton.createButton(imageName: "timeline_icon_comment", title: "评论")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

