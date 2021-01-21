//
//  ViewController.swift
//  ARDicee
//
//  Created by Vlad Lopes on 02/06/20.
//  Copyright © 2020 Vlad Lopes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
// the line below show the points used by device to detect a surface
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
//
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let sphere = SCNSphere(radius: 0.15)
//        sphere.materials = [material]
//
//
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y: 3.1, z: -3.5)
//        node.geometry = sphere // cube
//
//        sceneView.scene.rootNode.addChildNode(node)
//
//        sceneView.autoenablesDefaultLighting = true
//
        
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
//
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
// This line below does the same the next commented ones
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
        
        node.addChildNode(planeNode)
        
/*        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
 // A horizontal plane has just x and z dimension, doen't have y (height dimension)
           
            createPlane(withPlaneAnchor: planeAnchor)
            
            node.addChildNode(planeNode)
        } else {
            print( "Fail detecting plane anchor")
            return
        }
 */
    }
    
    //MARK: - Dice rendering methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                addDice(atLocation: hitResult)
            } else {
                print("Touched another place")
            }
        }
    }
    
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
                   
        let planeNode = SCNNode()
// To define a node where the plane will be setted
           planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
// A plane is created vertically, so we must rotate it to horizontal position
// rotating it in -90 degrees (in radians) setting the x dimension with 1
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
       
        let material = SCNMaterial()
       
        material.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
       
        plane.materials = [material]
       
        planeNode.geometry = plane
        
        return planeNode
           
    }
    
    func addDice(atLocation location: ARHitTestResult) {
          let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
       
           if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
// This will put the virtual object on the touched point of surface
// As the point is central in object, is necessary add half of it (the radius osf sphere)in y (height) position
           diceNode.position = SCNVector3(
               x: location.worldTransform.columns.3.x,
               y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
               z: location.worldTransform.columns.3.z
               )
           
           diceArray.append(diceNode)
           
           sceneView.scene.rootNode.addChildNode(diceNode)
            
            sceneView.autoenablesDefaultLighting = true

           roll(dice: diceNode)
        }
    }

    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeDices(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty {
            for dice in diceArray{
                dice.removeFromParentNode()
            }
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    func rollAll() {
// Including ! before the variable is a way to invert the meaning, in this case "if its not empty")
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
// Creating 2 random numbers to position the dice, and using the 90 degrees to rotate it
// Multiply by 5 (must use an impar number) to rotate the dice more times
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)

        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 5),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 0.5)
            )
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
