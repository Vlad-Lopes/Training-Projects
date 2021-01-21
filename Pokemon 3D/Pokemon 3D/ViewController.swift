//
//  ViewController.swift
//  Pokemon 3D
//
//  Created by Vlad Lopes on 04/06/20.
//  Copyright © 2020 Vlad Lopes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let imageNode = SCNNode()
// Create a plane with the same measure as the anchor (a detected image) and
// make it semi-transparent
        if let imageAnchor = anchor as? ARImageAnchor {
            let imagePlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            imagePlane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
// Define a node to the plane and rotate it in -90 degrees
            let planeNode = SCNNode(geometry: imagePlane)
            planeNode.eulerAngles.x = -Float.pi / 2
        
            imageNode.addChildNode(planeNode)
            
            if imageAnchor.referenceImage.name == "Eevee-card" {
                if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn"),
                    let pokeNode = pokeScene.rootNode.childNodes.first {
                    pokeNode.eulerAngles.x = Float.pi / 2
                    
                planeNode.addChildNode(pokeNode)
                }
            }
            if imageAnchor.referenceImage.name == "Oddish-card" {
                if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn"),
                    let pokeNode = pokeScene.rootNode.childNodes.first {
                    pokeNode.eulerAngles.x = Float.pi / 2
                
                planeNode.addChildNode(pokeNode)
                }
            }
        }
        return imageNode
    }
}
