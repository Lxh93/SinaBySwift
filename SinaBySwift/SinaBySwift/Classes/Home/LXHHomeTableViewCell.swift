//
//  LXHHomeTableViewCell.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/19.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import SDWebImage

let LXHStatusCell = "LXHStatusCell"
let margin:CGFloat = 10
let width = UIScreen.main.bounds.width

enum homeCellIdentifier:String{
    case forwardCell = "forwardCell"
    case normalCell = "normalCell"
    static func cellID(status:LXHStatus)->String{
        return status.retweeted_status != nil ? forwardCell.rawValue : normalCell.rawValue
    }
}
class LXHHomeTableViewCell: UITableViewCell {
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化UI
        setupUI()
        
    }
    
    
    
    /// 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint!
    /// 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint!
    /// 保存配图距离顶部的高度约束
    var pictureTopCons: NSLayoutConstraint!
    
    var status = LXHStatus(){
        didSet{
            headerView.status = status
            pictureView.status = (status.retweeted_status != nil ? status.retweeted_status! : status)
            contentLabel.text = status.text
            let size = pictureView.calculateImageSize()
            if size.height == 0 {
                pictureTopCons.constant = 0;
            }else{
                pictureTopCons.constant = 10
            }
            pictureHeightCons?.constant = size.height
            
            pictureWidthCons?.constant = size.width
        }
    }
    
    
    func setupUI()
    {
        
        contentView.addSubview(headerView)
        
        contentView.addSubview(contentLabel)
        
        contentView.addSubview(pictureView)
        
        contentView.addSubview(footerView)
        
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        
        
        let _ = headerView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: contentView, size: CGSize.init(width: width, height: 60), offset: CGPoint.zero)
        let _ = contentLabel.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: headerView, size: nil, offset: CGPoint.init(x: 10, y: 10))
        
        
        let _ = footerView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -margin, y: margin))
        
    }
    /// 正文
    lazy var contentLabel: UILabel =
    {
        let label = UILabel.createLabel(color: UIColor.darkGray, fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - margin*2
        return label
    }()
    
    func getRowHeight(lxhStatus:LXHStatus)->CGFloat{
        status = lxhStatus
        layoutIfNeeded()
        return footerView.frame.maxY
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var pictureView:LXHHomePictureView = LXHHomePictureView()
    /// 顶部部工具条
    private lazy var headerView: LXHHomeCellTopView = LXHHomeCellTopView()
    /// 底部工具条
    lazy var footerView: LXHHomeCellFooterView = LXHHomeCellFooterView()
    
}
