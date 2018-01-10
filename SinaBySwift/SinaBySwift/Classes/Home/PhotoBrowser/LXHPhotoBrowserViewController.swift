//
//  LXHPhotoBrowserViewController.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2018/1/2.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit
let photoBrowserCell = "photoBrowserCell"

class LXHPhotoBrowserViewController: UIViewController {
    var currentIndex: IndexPath?
    var pictureURLs: [URL]?
    init(index: IndexPath, urls: [URL])
    {
        
        currentIndex = index
        pictureURLs = urls
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoBrowsercollectionView.scrollToItem(at: currentIndex!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
    private func setupUI(){
        
        view.addSubview(photoBrowsercollectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        let _ = photoBrowsercollectionView.xmg_Fill(referView: view, insets: UIEdgeInsets.zero)
        
        let _ = closeBtn.xmg_AlignInner(type: XMG_AlignType.bottomLeft, referView: view, size: CGSize.init(width: 100, height: 30), offset: CGPoint.init(x: 16, y: -16))
        let _ = saveBtn.xmg_AlignInner(type: XMG_AlignType.bottomRight, referView: view, size: CGSize.init(width: 100, height: 30), offset: CGPoint.init(x: -16, y: -16))
        photoBrowsercollectionView.dataSource = self
        photoBrowsercollectionView.delegate = self
        photoBrowsercollectionView.register(LXHPhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCell)
    }
    private lazy var photoBrowsercollectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: photoBrowserLayout())
    
    private lazy var closeBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        return btn
    }()
    
    private lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        return btn
    }()
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    @objc func saveImage(){
        
        let index = photoBrowsercollectionView.indexPathsForVisibleItems.last!
        
        let cell = photoBrowsercollectionView.cellForItem(at: index) as! LXHPhotoBrowserCell
//        UIImageWriteToSavedPhotosAlbum(cell.imgView.image!, self, #selector(), nil)
        UIImageWriteToSavedPhotosAlbum(cell.imgView.image!, self,#selector(image(image:didFinishSavingWithError:contextInfo:)) , nil)
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:AnyObject){
        if error != nil{
            UIAlertController.showInfoInAlert(controller: self, message: "保存失败")
        }else{
            UIAlertController.showInfoInAlert(controller: self, message: "保存成功")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class photoBrowserLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}
extension LXHPhotoBrowserViewController:UICollectionViewDataSource,UICollectionViewDelegate,PhotoBrowserCellDelegate{
    func photoBrowserCellDidClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell, for: indexPath) as! LXHPhotoBrowserCell
        cell.imageURL = pictureURLs![indexPath.item]
        cell.photoBrowserCellDelegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}
