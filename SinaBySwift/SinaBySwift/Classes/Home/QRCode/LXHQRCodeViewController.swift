//
//  LXHQRCodeViewController.swift
//  Sina--Swift
//
//  Created by JinShiJinSheng on 2017/12/13.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit
import AVFoundation
class LXHQRCodeViewController: UIViewController {
    @IBOutlet weak var contrainView: UIView!
    @IBOutlet weak var contrainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scanlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scanlineView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        qRCodeTabbar.selectedItem = qRCodeTabbar.items?.first
        qRCodeTabbar.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let result = checkCameraAuth()
        checkCameraAuth()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        startAnimation()
    }
    @IBOutlet weak var qRCodeTabbar: UITabBar!
    
    @IBAction func closeQRCodeClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func startAnimation(){
   
        scanlineTopConstraint.constant = -self.contrainViewHeight.constant
        
        contrainView.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0) {
            
            UIView.setAnimationRepeatCount(MAXFLOAT)
            
            self.scanlineTopConstraint.constant = 0
            
            self.contrainView.layoutIfNeeded()
        }
        
    }
    
    func checkCameraAuth(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                if granted {
                    
                    DispatchQueue.main.async {
                        self.startAnimation()
                        self.startScan()
                    }
                }else{
                    self.showInfoInAlert(message: "拒绝授权")
                }
            })
        case .authorized:
            DispatchQueue.main.async {
                self.startAnimation()
                self.startScan()
            }
            
        case .denied,.restricted:
            showInfoInAlert(message: "授权失败")
            
        }
    }
    func showInfoInAlert(message:String){
        let alert = UIAlertController.init(title: "温馨提示", message:message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { _ in
                self.dismiss(animated: true, completion: nil)
        }
        alert .addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func startScan(){
        if device == nil {
            showInfoInAlert(message: "设备摄像头故障")
            
            return
        }
        if !session.canAddOutput(deviceOutput) {
            return
        }
        if !session.canAddInput(deviceInput!) {
            return
        }
        session.addInput(deviceInput!)
        session.addOutput(deviceOutput)
        deviceOutput.metadataObjectTypes = deviceOutput.availableMetadataObjectTypes
        
        deviceOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.addSublayer(drawLayer)
        session.startRunning()
    }
    private lazy var deviceOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput()

    let device = AVCaptureDevice.default(for: AVMediaType.video)
    private lazy var session :AVCaptureSession = AVCaptureSession()
    private lazy var deviceInput:AVCaptureDeviceInput? = {
        
        if (device != nil) {
            do{
                let input = try AVCaptureDeviceInput.init(device: device!)
                return input
            }catch{
                print(error)
                return nil
            }
        }else{
       
            return nil
        }
        
    }()
    
    private lazy var previewLayer:AVCaptureVideoPreviewLayer={
       let layer = AVCaptureVideoPreviewLayer.init(session: self.session)
        layer.frame = UIScreen.main.bounds
        return layer
    }()
    private lazy var drawLayer:CALayer = {
       let layer = CALayer()
        layer.frame = UIScreen.main.bounds
        return layer
    }()
    
}
extension LXHQRCodeViewController:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        for object in metadataObjects {
            
            if object is AVMetadataMachineReadableCodeObject{
                
                let result = object as! AVMetadataMachineReadableCodeObject
                
                let codeObject = previewLayer.transformedMetadataObject(for: result)
              
                clearConers()
                
                drawCorners(codeObject: codeObject as! AVMetadataMachineReadableCodeObject)
                
            }
        }
        
    }
    func drawCorners(codeObject:AVMetadataMachineReadableCodeObject){
        
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3
        
        var point = codeObject.corners[0]
        let path = UIBezierPath()
        
        path.move(to:point)
        
//        point = codeObject.corners[2]
//        path.addLine(to: point)
//        point = codeObject.corners[1]
//        path.addLine(to: point)
//        point = codeObject.corners[3]
//        path.addLine(to: point)
        var index = 0
        while index < codeObject.corners.count-1{
            index += 1
            point = codeObject.corners[index]
            path.addLine(to: point)
        }
        path.close()
        layer.path = path.cgPath
        drawLayer.addSublayer(layer)
    }
    func clearConers(){
        
        if drawLayer.sublayers?.count == 0 || drawLayer.sublayers == nil {
            return
        }else{
            for layer in drawLayer.sublayers!{
                layer.removeFromSuperlayer()
            }
        }
        
    }
}
extension LXHQRCodeViewController:UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 100{
           
            contrainViewHeight.constant = 200
        }else{
            contrainViewHeight.constant = 120
            
        }
        scanlineView.layer.removeAllAnimations()
        startAnimation()
    }
}
