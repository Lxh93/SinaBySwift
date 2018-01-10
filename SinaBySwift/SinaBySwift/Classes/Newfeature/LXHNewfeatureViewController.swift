//
//  LXHNewfeatureViewController.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/16.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
let imageCount = 4

class LXHNewfeatureViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(LXHCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    init() {
        super.init(collectionViewLayout: LXHCollectionViewLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDataSource

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LXHCollectionViewCell
        
        // Configure the cell
        cell.indexItem = indexPath.item
        if indexPath.item != imageCount-1 {
            cell.startBtn.isHidden = true
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems.last!

        if path.item == imageCount-1 {
            let cell = collectionView.cellForItem(at: path)! as! LXHCollectionViewCell
            cell.startAnimation()
        }
    }
    
}
class LXHCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setCollectionView() {
        contentView.addSubview(iconImage)
        contentView.addSubview(startBtn)
        let _ = startBtn.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: contentView, size: nil, offset: CGPoint.init(x: 0, y: -160))
    }
    var indexItem:Int?{
        didSet{
            iconImage.image = UIImage.init(named: "new_feature_\(indexItem!+1)")
        }
    }
    lazy var iconImage:UIImageView = {
       let imageView = UIImageView.init(frame: UIScreen.main.bounds)
        return imageView
    }()
    func startAnimation(){
        startBtn.isHidden = false
        startBtn.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: UIViewAnimationOptions(rawValue:0), animations: {
            self.startBtn.transform = CGAffineTransform.identity
        }) { (_) in
            self.startBtn.isUserInteractionEnabled = true
        }
    }
    lazy var startBtn:UIButton = {
       let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: "new_feature_button"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "new_feature_button_highlighted"), for: .highlighted)
        btn.isHidden = true
        btn.isUserInteractionEnabled = false
        btn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        return btn
    }()
    @objc func startBtnClick(){
        let isLogin = LXHLoginAccount.userLogin()
        NotificationCenter.default.post(name: NSNotification.Name.init(LXHSwitchRootViewControllerKey), object: isLogin)
    }
}
class LXHCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        itemSize = UIScreen.main.bounds.size
        scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
    }
}
