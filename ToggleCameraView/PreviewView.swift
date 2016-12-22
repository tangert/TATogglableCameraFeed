//
//  PreviewView.swift
//  ToggleCameraView
//
//  Created by Tyler Angert on 12/22/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PreviewView: UIView {

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // MARK: UIView
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    
}
