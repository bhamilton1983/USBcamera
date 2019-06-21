//
//  ViewController.swift
//  USBcamera
//
//  Created by Brian Hamilton on 6/20/19.
//  Copyright © 2019 Brian Hamilton. All rights reserved.
//

import Cocoa
import ORSSerial
import VLCKit
import VideoToolbox
import AVFoundation
import IOKit.usb.IOUSBLib
import CoreMediaIO



class ViewController: NSViewController, VLCMediaDelegate {
   
    
  
   

    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var secondButton: NSButton!
    @IBOutlet weak var sendButton: NSButton!
   
  
    var serial = SerialPortDemoController()

    //8101040702FF
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(serial.serialPortManager.availablePorts)
        serial.serialPort = serial.serialPortManager.availablePorts[0]

    }
    
    @IBAction func sendSecondButtonData(_ sender: Any) {
     
    
        
        
        serial.serialPort = serial.serialPortManager.availablePorts[0]
       serial.serialPort?.open()
       serial.serialPort?.baudRate = 9600
        serial.serialPort?.numberOfStopBits = 1
        serial.serialPort?.parity = .none
        let data = "8101040736FF".hexaData
        serial.serialPort?.send(data)
     
      
    }
    @IBAction func stopButtonSendData(_ sender: Any) {
        // Do any additional setup after loading the view.
        do {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    //access granted
                } else {
                    
                }
            }
            let allDevies: [AVCaptureDevice] = AVCaptureDevice.devices(for: .video)
            let aDevice:AVCaptureDevice
            aDevice = allDevies[3]
            print(allDevies)
            let uvc: UVC = try UVC(device: aDevice)
          
//            uvc.autoFocus = false
//            uvc.focus = 0.5
//
//            uvc.autoExposure = false
//            uvc.exposure = 0.9
//            
//            uvc.autoWhitebalance = false
//            uvc.whitebalance = 0.9
//
//            print(uvc.brightness)
//            print(uvc.contrast)
//            print(uvc.gain)
//            print(uvc.saturation)
//            print(uvc.sharpness)
            
            let layer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: .init())
            layer.videoGravity = .resizeAspectFill
            layer.bounds = view.bounds
            
            try layer.session?.addInput(AVCaptureDeviceInput(device: aDevice))
            layer.session?.sessionPreset = .hd1280x720
            layer.session?.startRunning()
            
            view.layer = layer
            view.wantsLayer = true
            
        } catch {
            print(error)
        }
    }
    
    @IBAction func sendDataToCamera(_ sender: Any) {
         sendTheData()
    }
    
    
    func sendTheData () {
  
        serial.serialPort = serial.serialPortManager.availablePorts[0]
        serial.serialPort?.open()
        serial.serialPort?.baudRate = 9600
        serial.serialPort?.numberOfStopBits = 1
        serial.serialPort?.parity = .none
        let data = "8101040726FF".hexaData
        serial.serialPort?.send(data)
      
       
     
     
    
    }

    override var representedObject: Any? {
        didSet {
    
        }
    }

}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
