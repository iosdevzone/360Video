//
//  ViewController.swift
//  360Video
//
//  Created by idz on 5/1/16.
//  Copyright © 2016 iOS Developer Zone.
//  License: MIT https://raw.githubusercontent.com/iosdevzone/PanoView/master/LICENSE
//

import UIKit
import SceneKit
import CoreMotion
import SpriteKit
import AVFoundation

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    let cameraNode = SCNNode()
    
    
    @IBOutlet weak var sceneView: SCNView!
    
    func createSphereNode(material material: AnyObject?) -> SCNNode {
        let sphere = SCNSphere(radius: 20.0)
        sphere.firstMaterial!.doubleSided = true
        sphere.firstMaterial!.diffuse.contents = material
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(0,0,0)
        return sphereNode
    }
    
    func configureScene(node sphereNode: SCNNode) {
        // Set the scene
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        // Camera, ...
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(sphereNode)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func startCameraTracking() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
            [weak self](data: CMDeviceMotion?, error: NSError?) in
            
            guard let data = data else { return }
            
            let attitude: CMAttitude = data.attitude
            self?.cameraNode.eulerAngles = SCNVector3Make(Float(attitude.roll + M_PI/2.0), -Float(attitude.yaw), -Float(attitude.pitch))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sphereNode = createSphereNode(material:nil)
        configureScene(node: sphereNode)
        guard motionManager.deviceMotionAvailable else {
            fatalError("Device motion is not available")
        }
        startCameraTracking()
    }
    
    override func viewDidAppear(animated: Bool) {
        sceneView.play(self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

