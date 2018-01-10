//
//  LXHQRCodeCardViewController.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/15.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHQRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardImageV)
        title = "我的名片"
        view.backgroundColor = UIColor.lightGray
        let _ =  cardImageV.xmg_AlignInner(type: XMG_AlignType.center, referView: view, size: CGSize.init(width: 200, height: 200), offset: CGPoint())
        cardImageV.image = creatCardImage()
        
    }
    func creatCardImage() -> UIImage {
        let filter = CIFilter(name:"CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue("今世今生93".data(using: String.Encoding.utf8), forKey: "inputMessage")
        let ciImage = filter?.outputImage
        let cardImage = createNonInterpolatedUIImageFormCIImage(image: ciImage!, size: 300)
        let myIcon = UIImage(named:"myIcon")
        return creteImage(bgImage: cardImage, iconImage: myIcon!)
    }
    /**
     合成图片
     
     :param: bgImage   背景图片
     :param: iconImage 头像
     */
    private func creteImage(bgImage: UIImage, iconImage: UIImage) -> UIImage
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.draw(in: CGRect(origin:CGPoint.init(x: 0, y: 0), size: bgImage.size))
        // 3.绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
    
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
    
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage!
    }
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = (image.extent).integral
        let scale: CGFloat = min(size/extent.width, size/extent.width)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = .none
        
        bitmapRef.scaleBy(x: scale, y: scale)
       
        bitmapRef.draw(bitmapImage, in: extent)
        
        
        
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage.init(cgImage: scaledImage)
    }
    lazy var cardImageV = UIImageView()

}
