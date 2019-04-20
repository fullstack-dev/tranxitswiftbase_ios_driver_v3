//
//  QRCodeScanViewController.swift
//  Provider
//
//  Created by Sravani on 24/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanViewController: UIViewController{
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var qrcodeImageview: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK:- LocalVariable
    
    var  video = AVCaptureVideoPreviewLayer()
    var QRScanCompletion : ((String, String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrScanInitialization()
        initialLoads()
    }
}

//MARK:- LocalMethod

extension QRCodeScanViewController {
    
    func initialLoads() {
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped(sender:)), for: .touchUpInside)
        self.view.bringSubviewToFront(qrcodeImageview)
        self.view.bringSubviewToFront(closeButton)
    }
    
    func qrScanInitialization() {
        
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch {
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        session.startRunning()
    }
}

//MARK:- IBAction

extension QRCodeScanViewController {
    
    @objc func closeButtonTapped(sender : UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK:- AVCaptureMetadataOutputObjectsDelegate

extension QRCodeScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first{
            if metadataObject.type == .qr{
                let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject
                do {
                    if let validData = readableObject?.stringValue?.data(using: .utf8){
                        
                        let dict = try JSONDecoder().decode([String:String].self,from:validData)
                        //do stuff with dict
                        print(dict)
                        let phoneNumber = dict["phone_number"]
                        let countryCode = dict["country_code"]
                        self.QRScanCompletion!(countryCode ?? "", phoneNumber ?? "")
                        // AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
}



