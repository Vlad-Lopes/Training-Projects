//
//  ViewController.swift
//  AnimalIdentifier
//
//  Created by Vlad Lopes on 27/05/20.
//  Copyright © 2020 Vlad Lopes. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        UINavigationBar().barTintColor = .blue
        UINavigationBar().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let userPickerImage = info[.originalImage] as? UIImage {
            imageView.image = userPickerImage
            
            guard let ciImage = CIImage(image: userPickerImage) else {
                fatalError("Error converting image to CIImage")
            }
            
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect (image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: AnimalImageClassifier().model) else {
            fatalError("Create a ML Model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results as? [VNClassificationObservation] else {
                fatalError("Could not classified the image.")
            }
          
            if classification[0].confidence > 0.75 {
                if let animal = classification.first?.identifier {
                    self.navigationItem.title = animal.capitalized
                }
            } else {
                self.navigationItem.title = "Unindentified"
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)

    }
}

