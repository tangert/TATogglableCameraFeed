//
//  ViewController.swift
//  ToggleCameraView
//
//  Created by Tyler Angert on 12/22/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var showFeedButton: UIButton!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    
    var sessionIsActive = false
    var feedIsActive = false
    var videoDeviceInput: AVCaptureDeviceInput!
    var session: AVCaptureSession?
    
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var placeHolderLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        previewView.addGestureRecognizer(tap)
        previewView.isUserInteractionEnabled = true
        
        sessionLabel.text = "Session not started"
        feedLabel.text = "No feed"
        previewView.session = session
        
        placeHolderLayer.backgroundColor = UIColor.red.cgColor
        placeHolderLayer.frame = previewView.bounds

        
    }
    
    @IBAction func pressStartSession(_ sender: Any) {
        if sessionIsActive == false {
            
            session = AVCaptureSession()
            session?.sessionPreset = AVCaptureSessionPresetPhoto
            
            var defaultVideoDevice: AVCaptureDevice?
            
            if let frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                // In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
                defaultVideoDevice = frontCamera
            }
            
            var error: NSError?
            var input: AVCaptureDeviceInput!
            do {
                input = try AVCaptureDeviceInput(device: defaultVideoDevice)
            } catch let error1 as NSError {
                error = error1
                input = nil
                print("Error: \(error!.localizedDescription)")
            }
            
            if error == nil && (session?.canAddInput(input))! {
                session?.addInput(input)
            }
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            
            videoPreviewLayer!.frame = previewView.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            session?.startRunning()
            
            sessionLabel.text = "Session started"
            feedLabel.text = "Feed shown"
            
            feedIsActive = true
            sessionIsActive = true
        } else {
            session?.stopRunning()
            sessionLabel.text = "Session stopped"
            sessionIsActive = false
        }
    }
    
    @IBAction func pressShowFeed(_ sender: Any) {
      
        if sessionIsActive {
            if feedIsActive {
                previewView.layer.replaceSublayer(videoPreviewLayer!, with: placeHolderLayer)
                feedIsActive = false
                feedLabel.text = "Feed hidden"
            } else {
                previewView.layer.replaceSublayer(placeHolderLayer, with: videoPreviewLayer!)
                feedIsActive = true
                feedLabel.text = "Feed shown"
            }
        } else {
            print("Please turn on the session!")
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sessionIsActive {
            if feedIsActive {
                previewView.layer.replaceSublayer(videoPreviewLayer!, with: placeHolderLayer)
                feedIsActive = false
                feedLabel.text = "Feed hidden"
            } else {
                previewView.layer.replaceSublayer(placeHolderLayer, with: videoPreviewLayer!)
                feedIsActive = true
                feedLabel.text = "Feed shown"
            }
        } else {
            print("Please turn on the session!")
        }
    }
}
