//
//  ViewController.swift
//  VRCarApp
//
//  Created by Pallak Singh on 08/11/18.
//  Copyright © 2018 Pallak Singh. All rights reserved.
//

import UIKit
import CocoaMQTT
import CoreMotion

class ViewController: UITabBarController {
    
    private var mqttManager:MQTTManager!
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
        let ipAddressField = "192.168.13.197"
        let topic = "trail"
        mqttManager = MQTTManager.shared(host: ipAddressField,topic: topic)
        mqttManager.connect()
        
        

        
    }
  
    
    
    var isFirst  = true;
    
    override func viewDidAppear(_ animated: Bool) {
        var initialAttitude = CMAttitude()
        motionManager.deviceMotionUpdateInterval = 0.5
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical, to: OperationQueue.current!){ (motiondata, err) in
            guard let data = motiondata else {return}
            
             if self.isFirst == true {
                initialAttitude = data.attitude
                self.isFirst = false
            } else {
                let attitude = data.attitude
                attitude.multiply(byInverseOf: initialAttitude)
                let pitch = self.radiansToDegrees(attitude.pitch)
                let roll = self.radiansToDegrees(attitude.roll)
                
                print(pitch)
                if pitch < -50 {
                    self.mqttManager.publish(with: "right")
                    
                }
                
                if pitch > 50 {
                    self.mqttManager.publish(with: "left")
                }
                
                if roll < -50 {
                    self.mqttManager.publish(with: "up")
                    
                }
                
                if roll > 50 {
                    self.mqttManager.publish(with: "down")
                } else if roll < 50 && roll > -50 && pitch < 50 && pitch > -50 {
                    self.mqttManager.publish(with: "0")
                }
                
                
                
                print(roll)
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        motionManager.gyroUpdateInterval = 0.3
//        var prevData = 9
//        var currentData = 10
//        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data,error) in
//            if let myData = data {
//                if myData.rotationRate.x > 2{
//                    print("tilted left")
//                    currentData = 3
//                    if prevData == 4 && currentData == 3  {
//                        self.mqttManager.publish(with: "stop")
//
//                    } else {
//                        self.mqttManager.publish(with: "tilted left")
//
//                    }
//                    prevData = 3
//
//                }
//                if myData.rotationRate.x < -2{
//                    print("tilted right")
//                    currentData = 4
//                    if prevData == 3 && currentData == 4  {
//                        self.mqttManager.publish(with: "stop")
//
//                    } else {
//                       self.mqttManager.publish(with: "tilted right")
//                    }
//                    prevData = 4
//                }
//                if myData.rotationRate.y > 2 {
//                    print("down")
//                    currentData = 5
//                    if prevData == 6 && currentData == 5 {
//                         self.mqttManager.publish(with: "stop")
//                    } else {
//                        self.mqttManager.publish(with: "down")
//                    }
//                    prevData = 5
//                }
//                if myData.rotationRate.y < -2{
//                    currentData = 6
//                    print("up")
//                    if prevData == 5 && currentData == 6 {
//                        self.mqttManager.publish(with: "stop")
//                    } else {
//                        self.mqttManager.publish(with: "up")
//                    }
//
//                    prevData = 6
//                }
////                if myData.rotationRate.x - middlePositon.x < 1 || myData.rotationRate.x - middlePositon.x > -1 {
////                    self.mqttManager.publish(with: "stop")
////                }
//
//
//            }
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        

    func radiansToDegrees(_ radian: Double) -> Float {
        return Float(radian * 180.0/Double.pi)
    }

}

//extension ViewController: PresenterProtocol{
//
//    func resetUIWithConnection(status: Bool){
//
//        ipAddressField.isEnabled = !status
//        topicField.isEnabled = !status
//        messageField.isEnabled = status
//        connectBtn.isEnabled = !status
//        sendBtn.isEnabled = status
//
//        if (status){
//            updateStatusViewWith(status: "Connected")
//        }else{
//            updateStatusViewWith(status: "Disconnected")
//        }
//    }
//    func updateStatusViewWith(status: String){
//
//        statusLabl.text = status
//    }
//
//    func update(message: String){
//
//        if let text = messageHistoryView.text{
//            let newText = """
//            \(text)
//            \(message)
//            """
//            messageHistoryView.text = newText
//        }else{
//            let newText = """
//            \(message)
//            """
//            messageHistoryView.text = newText
//        }
//
//        let myRange=NSMakeRange(messageHistoryView.text.count-1, 0);
//        messageHistoryView.scrollRangeToVisible(myRange)
//
//
//    }
//
//
//}
extension ViewController: UITabBarControllerDelegate {
    // Prevent automatic popToRootViewController on double-tap of UITabBarController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
}


