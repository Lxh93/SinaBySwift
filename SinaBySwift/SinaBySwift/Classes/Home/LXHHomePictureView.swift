//
//  LXHHomePictureView.swift
//  SinaBySwift
//
//  Created by 李小华 on 2017/12/25.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import SDWebImage
class LXHHomePictureView: UICollectionView {

    var status = LXHStatus()
    {
        didSet{
            // 1. 刷新表格
           
            reloadData()
        }
    }
    private lazy var pictureViewLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: pictureViewLayout)
        setupPictureView()
    }
    private func setupPictureView(){
        register(pictureCell.self, forCellWithReuseIdentifier: LXHStatusCell)
        dataSource = self
        delegate = self
        pictureViewLayout.minimumLineSpacing = 5
        pictureViewLayout.minimumInteritemSpacing = 5
        
        backgroundColor = UIColor.darkGray
        
    }
    
    func calculateImageSize()->(CGSize){
        let count = status.storedPicURLS.count
        
        if count == 0 {
            return CGSize.zero
        }
        if count == 1 {
            let key = status.storedPicURLS.first?.absoluteString
            
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey:key)
            pictureViewLayout.itemSize = image != nil ? image!.size:CGSize.zero
            
            return image != nil ? image!.size:CGSize.zero
        }
        let width:CGFloat = (UIScreen.main.bounds.size.width-margin*3)/3
        pictureViewLayout.itemSize = CGSize.init(width: width, height: width)
        if count == 4 {
            let viewWidth = width*2+margin*0.5
            
            return CGSize.init(width: viewWidth, height: viewWidth)
        }
        let colNumber:Int = 3
        
        // (8 - 1) / 3 + 1
        let rowNumber:Int = (count - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = CGFloat(colNumber) * width + CGFloat((colNumber - 1)) * 5
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = CGFloat(rowNumber) * width + CGFloat((rowNumber - 1)) * 5
        
        return CGSize(width: viewWidth, height: viewHeight)
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// 自定义配图cell
class pictureCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    func setupUI(){
        contentView.addSubview(Avatar)
        Avatar.addSubview(gifImageView)
        let _ = Avatar.xmg_Fill(referView: self, insets: UIEdgeInsets.zero)
        let _ = gifImageView.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: Avatar, size: nil, offset: .zero)
    }
    private lazy var gifImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_vgirl"))
        iv.isHidden = true
        return iv
    }()
    var imageURL:URL?{
        didSet{
            Avatar.contentMode = UIViewContentMode.scaleAspectFill
            
            Avatar.clipsToBounds = true
            
            Avatar.sd_setImage(with: imageURL, completed: nil)
            
            // 2.判断是否需要显示gif图标 // GIF
            if (imageURL!.absoluteString as NSString).pathExtension.lowercased() == "gif"
            {
                gifImageView.isHidden = false
            }
            
        }
    }
    lazy var Avatar:UIImageView = UIImageView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// 选中图片的通知名称
let LXHStatusPictureViewSelected = "LXHStatusPictureViewSelected"
/// 当前选中图片的索引对应的key
let LXHStatusPictureViewIndexKey = "LXHStatusPictureViewIndexKey"
/// 需要展示的所有图片对应的key
let LXHStatusPictureViewURLsKey = "LXHStatusPictureViewURLsKey"
// MARK: - UICollectionViewDataSource
extension LXHHomePictureView:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return status.storedPicURLS.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LXHStatusCell, for: indexPath) as! pictureCell
        
        cell.imageURL = status.storedPicURLS[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let info = [LXHStatusPictureViewIndexKey:indexPath,LXHStatusPictureViewURLsKey:status.LargePictureURLS!] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name.init(LXHStatusPictureViewSelected), object: self, userInfo: info)
    }
}
