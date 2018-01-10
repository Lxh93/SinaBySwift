//
//  LXHPhotoBrowserCell.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2018/1/2.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit
protocol PhotoBrowserCellDelegate : NSObjectProtocol
{
    func photoBrowserCellDidClose()
}
class LXHPhotoBrowserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate : PhotoBrowserCellDelegate?
    
    var imageURL:URL?
    {
        didSet{
            reset()
            activity.startAnimating()
            
            imgView.sd_setImage(with: imageURL) { (image, _, _, _) in
                self.activity.stopAnimating()
                self.imageSizeToFit(image: image!)
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    /**
     重置scrollview和imageview的属性
     */
    private func reset()
    {
        // 重置scrollview
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
        
        // 重置imageview
        imgView.transform = CGAffineTransform.identity
    }
    private func imageSizeToFit(image:UIImage){
        let size = displaySize(image: image)
        
        if size.height > screenHeight {
            
            imgView.frame = CGRect.init(origin: CGPoint.zero, size: size)
            
            scrollView.contentSize = CGSize.init(width: 0, height: size.height)
        
        }else{
            
            let oY = (screenHeight - size.height) * 0.5

            scrollView.contentInset = UIEdgeInsets.init(top: oY, left: 0, bottom: oY, right: 0)
//            imgView.center = self.center
            
            imgView.frame = CGRect.init(origin: CGPoint.zero, size: size)
        }
    }
    /**
     按照图片的宽高比计算图片显示的大小
     */
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = screenWidth
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    private func setupUI(){
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(imgView)
        contentView.addSubview(activity)
        let _ = activity.xmg_AlignInner(type: XMG_AlignType.center, referView: contentView, size: nil, offset: CGPoint.zero)
//        let _ = scrollView.xmg_Fill(referView: contentView, insets: UIEdgeInsets.zero)
        
    }
    private lazy var scrollView:UIScrollView = {
        
        let scrollView = UIScrollView.init(frame: screenBounds)
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        return scrollView
        
    }()
    
    lazy var imgView:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(close))
        img.addGestureRecognizer(tap)
        return img
    }()
    @objc func close(){
        photoBrowserCellDelegate?.photoBrowserCellDidClose()
    }
    private lazy var activity:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LXHPhotoBrowserCell:UIScrollViewDelegate{
    //告诉系统需要缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 注意: 缩放的本质是修改transfrom, 而修改transfrom不会影响到bounds, 只有frame会受到影响
        //        print(view?.bounds)
        //        print(view?.frame)
        var offsetX = (screenWidth - view!.frame.width) * 0.5
        var offsetY = (screenHeight - view!.frame.height) * 0.5
        
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}
