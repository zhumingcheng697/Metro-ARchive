//
//  ViewControllerWorld.swift
//  MetroARchive
//
//  Created by McCoy Zhu on 1/10/20.
//  Copyright © 2020 McCoy Zhu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SafariServices

class ViewControllerWorld: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func openInfo(_ sender: Any) {
        let browser = SFSafariViewController(url: URL(string: "https://www.sammylevin.com/metro-archive-info")!)
        present(browser, animated: true)
    }
    
    public let undergroundVid = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let restaurantVid1 = AVPlayer(url: Bundle.main.url(forResource: "Contemporary_Restaurant_1", withExtension: "mp4", subdirectory: "art.scnassets")!)
    
    public let restaurantVid2 = AVPlayer(url: Bundle.main.url(forResource: "Contemporary_Closing_1", withExtension: "mp4", subdirectory: "art.scnassets")!)
    
    public let tuxedoNode = SCNScene(named: "art.scnassets/tuxedo_v10.scn")!.rootNode.childNodes[0]
    
    public let centeredTuxedo = SCNScene(named: "art.scnassets/tuxedo_v11.scn")!.rootNode.childNodes[0]
    
    public let twoDoyerNode = SCNScene(named: "art.scnassets/2Doyers_v2.scn")!.rootNode.childNodes[0]
    
    public let buildingNode = SCNScene(named: "art.scnassets/8Buildings.scn")!.rootNode.childNodes[0]
    
    public var modelNodes = [SCNNode]()
    
    public var historicNodes = [SCNNode]()
    
    public var contemporaryNodes = [SCNNode]()
    
    public var immersiveOnlyNodes = [SCNNode]()
    
    public var trackerNodes = SCNNode()
    
    public var iconNodes = SCNNode()
    
    public var closestIndex = 0;
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    func switchMode(withTransition: Bool = true) {
        if withTransition {
            switch self.modeSelector.selectedSegmentIndex {
            case 0:
                for node in self.modelNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.3))
                    }
                }
                for node in self.historicNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.3))
                        if node.categoryBitMask != 1 << 3 {
                            node.runAction(.moveBy(x: 0, y: 0.1, z: 0, duration: 0.3))
                        }
                    }
                }
                for node in self.contemporaryNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                        if node.categoryBitMask != 1 << 3 {
                            node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.3))
                        }
                    }
                }
                for node in self.immersiveOnlyNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                    }
                }
            case 2:
                for node in self.modelNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                    }
                }
                for node in self.historicNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                        if node.categoryBitMask != 1 << 3 {
                            node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.3))
                        }
                    }
                }
                for node in self.contemporaryNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.3))
                        if node.categoryBitMask != 1 << 3 {
                            node.runAction(.moveBy(x: 0, y: 0.1, z: 0, duration: 0.3))
                        }
                    }
                }
                for node in self.immersiveOnlyNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                    }
                }
            default:
                for node in self.modelNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.3))
                    }
                }
                for node in self.historicNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                        if node.categoryBitMask != 1 << 3 {
                            node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.3))
                        }
                    }
                }
                for node in self.contemporaryNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.3))
                        if node.categoryBitMask != 1 << 3 {
                            node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.3))
                        }
                    }
                }
                for node in self.immersiveOnlyNodes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.3))
                    }
                }
            }
        } else {
            switch self.modeSelector.selectedSegmentIndex {
            case 0:
                for node in self.modelNodes {
                    node.opacity = 1
                }
                for node in self.historicNodes {
                    node.opacity = 1
                }
                for node in self.contemporaryNodes {
                    node.opacity = 0
                }
                for node in self.immersiveOnlyNodes {
                    node.opacity = 0
                }
            case 2:
                for node in self.modelNodes {
                    node.opacity = 0
                }
                for node in self.historicNodes {
                    node.opacity = 0
                }
                for node in self.contemporaryNodes {
                    node.opacity = 1
                }
                for node in self.immersiveOnlyNodes {
                    node.opacity = 0
                }
            default:
                for node in self.modelNodes {
                    node.opacity = 1
                }
                for node in self.historicNodes {
                    node.opacity = 0
                }
                for node in self.contemporaryNodes {
                    node.opacity = 0
                }
                for node in self.immersiveOnlyNodes {
                    node.opacity = 1
                }
            }
        }
    }
    
    @objc func switchModeListener(sender: UISegmentedControl) {
        self.switchMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        for vid in [self.restaurantVid1, self.restaurantVid2] {
            loopVideo(videoPlayer: vid)
        }
        
        self.modeSelector.alpha = 0
        self.modeSelector.isUserInteractionEnabled = false
        self.modeSelector.addTarget(self, action: #selector(self.switchModeListener(sender:)), for: .valueChanged)
        
        self.infoButton.backgroundColor = UIColor(named: "selectedSegment")
        self.infoButton.layer.cornerRadius = 7
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        let detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main)!
        
        configuration.detectionImages = detectionImages
        configuration.maximumNumberOfTrackedImages = 3
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view == self.sceneView {
            let viewTouchLocation: CGPoint = touch.location(in: sceneView)
            if let result = sceneView.hitTest(viewTouchLocation, options: nil).first {
                
                if let content = result.node.geometry?.firstMaterial?.diffuse.contents {
                    if content as? AVPlayer == self.restaurantVid2 || content as? UIImage == UIImage(named: "Contemporary_Closing_2") {
                        UIApplication.shared.open(URL(string: "nytimes://www.nytimes.com/2019/12/24/upshot/chinese-restaurants-closing-upward-mobility-second-generation.html")!)
                    }
                    if content as? AVPlayer == self.restaurantVid1 {
                        UIApplication.shared.open(URL(string: "nytimes://www.nytimes.com/2017/02/14/dining/chinese-tuxedo-restaurant-review.html")!)
                    }
                    if content as? UIImage == UIImage(named: "Contemporary_Restaurant_2") {
                        UIApplication.shared.open(URL(string: "https://maps.apple.com/?address=5%20Doyers%20St,%20New%20York,%20NY%20%2010013,%20United%20States&ll=40.714290,-73.998077&q=5%20Doyers%20St&_ext=EiYpu0Plq9paREAx47QmlkGAUsA5ORkLCAFcREBBwXsSaX9/UsBQBA%3D%3D")!)
                    }
                }
                
            }
            
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        let light = SCNLight()
        light.type = .directional
        
        if let imageAnchor = anchor as? ARImageAnchor {
            var n: Int
            var vid: AVPlayer
            var modelNode: SCNNode
            switch imageAnchor.referenceImage.name {
                
            case "Underground":
                n = 1
                vid = self.undergroundVid
                modelNode = self.buildingNode
                modelNode.scale = SCNVector3(0.001,0.001,0.001)
            
            case "Lease":
                n = 2
                vid = self.undergroundVid
                modelNode = self.tuxedoNode
                modelNode.position.x = 4.5
                modelNode.position.y = -0.01
                modelNode.position.z = 4
                modelNode.eulerAngles.x = -.pi / 2 - 0.05
                modelNode.scale = SCNVector3(0.0255, 0.0255, 0.0255)
                
                let historicNode = SCNNode()
                let contemporaryNode = SCNNode()
                
                let imgPlaneA = SCNPlane(width: 2.3, height: 1.38)
                imgPlaneA.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Tuxedo_Intro")
                imgPlaneA.firstMaterial?.lightingModel = .constant
                
                let imgNodeA = SCNNode(geometry: imgPlaneA)
                imgNodeA.position.x = -2.7
                
                let imgPlaneC = SCNPlane(width: 1.6, height: 2)
                imgPlaneC.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Peace_Dinner")
                imgPlaneC.firstMaterial?.lightingModel = .constant
                
                let imgNodeC = SCNNode(geometry: imgPlaneC)
                imgNodeC.position.x = -0.2
                
                let imgPlaneB1 = SCNPlane(width: 0.96, height: 2.3)
                imgPlaneB1.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Tom_Lee")
                imgPlaneB1.firstMaterial?.lightingModel = .constant
                
                let imgNodeB1 = SCNNode(geometry: imgPlaneB1)
                imgNodeB1.position.x = 1.5
                
                let imgPlaneB2 = SCNPlane(width: 0.96, height: 2.3)
                imgPlaneB2.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Mock_Duck")
                imgPlaneB2.firstMaterial?.lightingModel = .constant
                
                let imgNodeB2 = SCNNode(geometry: imgPlaneB2)
                imgNodeB2.position.x = 2.8
                
                let imgPlaneD1 = SCNPlane(width: 1.6, height: 1.55)
                imgPlaneD1.firstMaterial?.diffuse.contents = UIImage(named: "Contemporary_Restaurant_2")
                imgPlaneD1.firstMaterial?.lightingModel = .constant
                
                let imgNodeD1 = SCNNode(geometry: imgPlaneD1)
                imgNodeD1.position.x = -0.9
                
                let imgPlaneD2 = SCNPlane(width: 1.6, height: 1.55)
                imgPlaneD2.firstMaterial?.diffuse.contents = UIImage(named: "Contemporary_Closing_2")
                imgPlaneD2.firstMaterial?.lightingModel = .constant
                
                let imgNodeD2 = SCNNode(geometry: imgPlaneD2)
                imgNodeD2.position.x = 2.6
                
                let vidPlaneE1 = SCNPlane(width: 1.6, height: 1.55)
                vidPlaneE1.firstMaterial?.diffuse.contents = self.restaurantVid1
                vidPlaneE1.firstMaterial?.lightingModel = .constant
                
                let vidNodeE1 = SCNNode(geometry: vidPlaneE1)
                vidNodeE1.position.x = -2.6
                
                let vidPlaneE2 = SCNPlane(width: 1.6, height: 1.55)
                vidPlaneE2.firstMaterial?.diffuse.contents = self.restaurantVid2
                vidPlaneE2.firstMaterial?.lightingModel = .constant
                
                let vidNodeE2 = SCNNode(geometry: vidPlaneE2)
                vidNodeE2.position.x = 0.9
                
                historicNode.addChildNode(imgNodeA)
                historicNode.addChildNode(imgNodeC)
                historicNode.addChildNode(imgNodeB1)
                historicNode.addChildNode(imgNodeB2)
                historicNode.eulerAngles.x = -.pi / 2
                historicNode.position.x = -0.5
                historicNode.position.y = 2
                historicNode.position.z = 2
                
                contemporaryNode.addChildNode(imgNodeD1)
                contemporaryNode.addChildNode(imgNodeD2)
                contemporaryNode.addChildNode(vidNodeE1)
                contemporaryNode.addChildNode(vidNodeE2)
                contemporaryNode.eulerAngles.x = -.pi / 2
                contemporaryNode.position.x = -0.5
                contemporaryNode.position.y = 2
                contemporaryNode.position.z = 2
                
                self.historicNodes.append(historicNode)
                self.contemporaryNodes.append(contemporaryNode)
                
                node.addChildNode(historicNode)
                node.addChildNode(contemporaryNode)
            
            case "Target":
                let factor = Float(imageAnchor.referenceImage.physicalSize.width / 0.26)
                n = 3
                vid = self.undergroundVid
                modelNode = self.buildingNode
                modelNode.position.z = -0.016 * factor
                modelNode.scale = SCNVector3(0.00075 * factor, 0.00075 * factor, 0.00075 * factor)
                
                let twoDoyer = self.twoDoyerNode
                twoDoyer.eulerAngles.y = -.pi / 4
                twoDoyer.scale = SCNVector3(0.0002 * factor, 0.0002 * factor, 0.0002 * factor)
                
                self.contemporaryNodes.append(twoDoyer)
                node.addChildNode(twoDoyer)
                
                let tuxedo = self.centeredTuxedo
                tuxedo.eulerAngles.y = -.pi / 4
                tuxedo.scale = SCNVector3(0.0002 * factor, 0.0002 * factor, 0.0002 * factor)
                
                self.historicNodes.append(tuxedo)
                node.addChildNode(tuxedo)
                
                let trackerNode = SCNNode()
                
                let iconPlane1 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane1.firstMaterial?.diffuse.contents = UIImage(named: "icon1")
                iconPlane1.firstMaterial?.lightingModel = .constant
                
                let iconNode1 = SCNNode(geometry: iconPlane1)
                iconNode1.position.x =  -0.075 * factor
                iconNode1.position.z = 0.095 * factor
                iconNode1.eulerAngles.x = -.pi / 2
                
                let iconPlane2 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane2.firstMaterial?.diffuse.contents = UIImage(named: "icon2")
                iconPlane2.firstMaterial?.lightingModel = .constant
                
                let iconNode2 = SCNNode(geometry: iconPlane2)
                iconNode2.position.x =  0.031 * factor
                iconNode2.position.z = 0.095 * factor
                iconNode2.eulerAngles.x = -.pi / 2
                
                let iconPlane3 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane3.firstMaterial?.diffuse.contents = UIImage(named: "icon3")
                iconPlane3.firstMaterial?.lightingModel = .constant
                
                let iconNode3 = SCNNode(geometry: iconPlane3)
                iconNode3.position.x =  0.095 * factor
                iconNode3.position.z = 0.075 * factor
                iconNode3.eulerAngles.x = -.pi / 2
                iconNode3.eulerAngles.y = +.pi / 2
                
                let iconPlane4 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane4.firstMaterial?.diffuse.contents = UIImage(named: "icon4")
                iconPlane4.firstMaterial?.lightingModel = .constant
                
                let iconNode4 = SCNNode(geometry: iconPlane4)
                iconNode4.position.x =  0.095 * factor
                iconNode4.position.z = -0.031 * factor
                iconNode4.eulerAngles.x = -.pi / 2
                iconNode4.eulerAngles.y = +.pi / 2
                
                let iconPlane5 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane5.firstMaterial?.diffuse.contents = UIImage(named: "icon5")
                iconPlane5.firstMaterial?.lightingModel = .constant
                
                let iconNode5 = SCNNode(geometry: iconPlane5)
                iconNode5.position.x =  0.075 * factor
                iconNode5.position.z = -0.095 * factor
                iconNode5.eulerAngles.x = -.pi / 2
                iconNode5.eulerAngles.y = -.pi
                
                let iconPlane6 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane6.firstMaterial?.diffuse.contents = UIImage(named: "icon6")
                iconPlane6.firstMaterial?.lightingModel = .constant
                
                let iconNode6 = SCNNode(geometry: iconPlane6)
                iconNode6.position.x =  -0.031 * factor
                iconNode6.position.z = -0.095 * factor
                iconNode6.eulerAngles.x = -.pi / 2
                iconNode6.eulerAngles.y = -.pi
                
                let iconPlane7 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane7.firstMaterial?.diffuse.contents = UIImage(named: "icon7")
                iconPlane7.firstMaterial?.lightingModel = .constant
                
                let iconNode7 = SCNNode(geometry: iconPlane7)
                iconNode7.position.x =  -0.095 * factor
                iconNode7.position.z = -0.075 * factor
                iconNode7.eulerAngles.x = -.pi / 2
                iconNode7.eulerAngles.y = -.pi / 2
                
                let iconPlane8 = SCNPlane(width: CGFloat(0.016 * factor), height: CGFloat(0.016 * factor))
                iconPlane8.firstMaterial?.diffuse.contents = UIImage(named: "icon8")
                iconPlane8.firstMaterial?.lightingModel = .constant
                
                let iconNode8 = SCNNode(geometry: iconPlane8)
                iconNode8.position.x =  -0.095 * factor
                iconNode8.position.z = 0.031 * factor
                iconNode8.eulerAngles.x = -.pi / 2
                iconNode8.eulerAngles.y = -.pi / 2
                
                let iconNode = SCNNode()
                iconNode.addChildNode(iconNode1)
                iconNode.addChildNode(iconNode2)
                iconNode.addChildNode(iconNode3)
                iconNode.addChildNode(iconNode4)
                iconNode.addChildNode(iconNode5)
                iconNode.addChildNode(iconNode6)
                iconNode.addChildNode(iconNode7)
                iconNode.addChildNode(iconNode8)
                
                self.iconNodes = iconNode
//                self.immersiveOnlyNodes.append(iconNode)
                
                node.addChildNode(iconNode)
                
//                let sphere1 = SCNSphere(radius: 0.01)
//                sphere1.firstMaterial?.diffuse.contents = UIColor.red
//                sphere1.firstMaterial?.lightingModel = .constant
                
//                let node1 = SCNNode(geometry: sphere1)
                let node1 = SCNNode()
                node1.position.x = -0.032 * factor
                node1.position.z = 0.13 * factor
                
//                let sphere2 = SCNSphere(radius: 0.01)
//                sphere2.firstMaterial?.diffuse.contents = UIColor.orange
//                sphere2.firstMaterial?.lightingModel = .constant
                
//                let node2 = SCNNode(geometry: sphere2)
                let node2 = SCNNode()
                node2.position.x = 0.08 * factor
                node2.position.z = 0.13 * factor
                
//                let sphere3 = SCNSphere(radius: 0.01)
//                sphere3.firstMaterial?.diffuse.contents = UIColor.yellow
//                sphere3.firstMaterial?.lightingModel = .constant
                
//                let node3 = SCNNode(geometry: sphere3)
                let node3 = SCNNode()
                node3.position.x = 0.13 * factor
                node3.position.z = 0.032 * factor
                
//                let sphere4 = SCNSphere(radius: 0.01)
//                sphere4.firstMaterial?.diffuse.contents = UIColor.green
//                sphere4.firstMaterial?.lightingModel = .constant
                
//                let node4 = SCNNode(geometry: sphere4)
                let node4 = SCNNode()
                node4.position.x = 0.13 * factor
                node4.position.z = -0.08 * factor
                
//                let sphere5 = SCNSphere(radius: 0.01)
//                sphere5.firstMaterial?.diffuse.contents = UIColor.cyan
//                sphere5.firstMaterial?.lightingModel = .constant
                
//                let node5 = SCNNode(geometry: sphere5)
                let node5 = SCNNode()
                node5.position.x = 0.032 * factor
                node5.position.z = -0.13 * factor
                
//                let sphere6 = SCNSphere(radius: 0.01)
//                sphere6.firstMaterial?.diffuse.contents = UIColor.blue
//                sphere6.firstMaterial?.lightingModel = .constant
                
//                let node6 = SCNNode(geometry: sphere6)
                let node6 = SCNNode()
                node6.position.x = -0.08 * factor
                node6.position.z = -0.13 * factor
                
//                let sphere7 = SCNSphere(radius: 0.01)
//                sphere7.firstMaterial?.diffuse.contents = UIColor.purple
//                sphere7.firstMaterial?.lightingModel = .constant
                
//                let node7 = SCNNode(geometry: sphere7)
                let node7 = SCNNode()
                node7.position.x = -0.13 * factor
                node7.position.z = -0.032 * factor
                
//                let sphere8 = SCNSphere(radius: 0.01)
//                sphere8.firstMaterial?.diffuse.contents = UIColor.gray
//                sphere8.firstMaterial?.lightingModel = .constant
                
//                let node8 = SCNNode(geometry: sphere8)
                let node8 = SCNNode()
                node8.position.x = -0.13 * factor
                node8.position.z = 0.08 * factor
                
                trackerNode.addChildNode(node1)
                trackerNode.addChildNode(node2)
                trackerNode.addChildNode(node3)
                trackerNode.addChildNode(node4)
                trackerNode.addChildNode(node5)
                trackerNode.addChildNode(node6)
                trackerNode.addChildNode(node7)
                trackerNode.addChildNode(node8)
                
                self.trackerNodes = trackerNode
                
//                self.immersiveOnlyNodes.append(trackerNode)
                
                node.addChildNode(trackerNode)
                
                let bgPlane1 = SCNPlane(width: CGFloat(0.165 * factor), height: CGFloat(0.165 * factor))
                bgPlane1.firstMaterial?.diffuse.contents = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
//                bgPlane1.firstMaterial?.lightingModel = .constant
                
                let bgPlane2 = SCNPlane(width: CGFloat(0.165 * factor), height: CGFloat(0.165 * factor))
                bgPlane2.firstMaterial?.diffuse.contents = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
//                bgPlane2.firstMaterial?.lightingModel = .constant
                
                let bgNode1 = SCNNode(geometry: bgPlane1)
                bgNode1.eulerAngles.x = -.pi / 2
                bgNode1.categoryBitMask = 1 << n
                
                let bgNode2 = SCNNode(geometry: bgPlane2)
                bgNode2.eulerAngles.x = -.pi / 2
                bgNode2.categoryBitMask = 1 << n
                
                bgNode1.position.y = -0.0001
                bgNode2.position.y = -0.0001
                
                light.categoryBitMask = 1 << n
                
                twoDoyer.categoryBitMask = 1 << n
                twoDoyer.light = light
                
                tuxedo.categoryBitMask = 1 << n
                tuxedo.light = light
                
                self.historicNodes.append(bgNode1)
                self.contemporaryNodes.append(bgNode2)
                node.addChildNode(bgNode1)
                node.addChildNode(bgNode2)
                
                for node in [bgNode1, bgNode2, twoDoyer, tuxedo, modelNode, iconNode] {
                    node.opacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    iconNode.runAction(.fadeIn(duration: 0.3))
                }
                
            default:
                return SCNNode()
            }
            
            var vidPlane: SCNPlane
            
            if n <= 3 {
                vidPlane = SCNPlane(width: max(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01, height: min(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01)
            } else {
                vidPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
            }
            
            vidPlane.firstMaterial?.diffuse.contents = vid
            vidPlane.firstMaterial?.lightingModel = .constant
            
            let vidNode = SCNNode(geometry: vidPlane)
            vidNode.eulerAngles.x = -.pi / 2
            vidNode.eulerAngles.y = (imageAnchor.referenceImage.physicalSize.width < imageAnchor.referenceImage.physicalSize.height && n <= 3 ? -.pi/2 : 0)
            
            light.categoryBitMask = 1 << n
            
            modelNode.categoryBitMask = 1 << n
            modelNode.light = light
            
            vidNode.categoryBitMask = 1 << n
            vidNode.light = light
            
            if n != 3 {
                self.modelNodes.append(modelNode)
            } else {
                self.immersiveOnlyNodes.append(modelNode)
            }
            
            vidNode.opacity = 0
            
            node.addChildNode(vidNode)
            node.addChildNode(modelNode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.switchMode(withTransition: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.modeSelector.alpha = 1
                })
                self.modeSelector.isUserInteractionEnabled = true
                
                if n == 2 {
                    self.restaurantVid1.play()
                    self.restaurantVid2.play()
                }
            }
            
            if n != 3 {
            node.opacity = 0
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                node.runAction(.fadeIn(duration: 0.5))
            }
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let lightEst = sceneView.session.currentFrame?.lightEstimate {
            node.childNodes[0].light?.intensity = lightEst.ambientIntensity * 0.8
            node.childNodes[0].light?.temperature = lightEst.ambientColorTemperature
        }
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        DispatchQueue.main.async {
            switch self.modeSelector.selectedSegmentIndex {
            case 1:
                if let cam = self.sceneView.session.currentFrame?.camera, self.trackerNodes.childNodes.count == 8 && self.iconNodes.childNodes.count == 8 {
                    var d = Float(100.0)
                    for i in 0 ..< 8 {
                        if simd_distance(self.trackerNodes.childNodes[i].simdWorldTransform.columns.3, cam.transform.columns.3) <= d {
                            d = simd_distance(self.trackerNodes.childNodes[i].simdWorldTransform.columns.3, cam.transform.columns.3)
                            self.closestIndex = i
                        }
                    }
                    
                    for material in (self.buildingNode.geometry?.materials)! {
                        material.diffuse.contents = UIColor.white
                    }
                    
                    for icon in self.iconNodes.childNodes {
                        icon.opacity = 0
                    }
                    
                    switch self.closestIndex {
                    case 0:
                        self.buildingNode.geometry?.materials[16].diffuse.contents = UIColor(named: "Orange")
                    case 1:
                        self.buildingNode.geometry?.materials[40].diffuse.contents = UIColor(named: "Orange")
                    case 2:
                        self.buildingNode.geometry?.materials[19].diffuse.contents = UIColor(named: "Orange")
                    case 3:
                        self.buildingNode.geometry?.materials[23].diffuse.contents = UIColor(named: "Orange")
                    case 4:
                        self.buildingNode.geometry?.materials[5].diffuse.contents = UIColor(named: "Orange")
                    case 5:
                        self.buildingNode.geometry?.materials[38].diffuse.contents = UIColor(named: "Orange")
                    case 6:
                        self.buildingNode.geometry?.materials[8].diffuse.contents = UIColor(named: "Orange")
                    case 7:
                        self.buildingNode.geometry?.materials[33].diffuse.contents = UIColor(named: "Orange")
                    default:
                        break
                    }
                    
                    self.iconNodes.childNodes[self.closestIndex].opacity = 1
                }
            default:
                for icon in self.iconNodes.childNodes {
                    icon.opacity = 0
                }
                
                self.iconNodes.childNodes[0].opacity = 1
            }
        }
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
