//
//  ViewController.swift
//  SeeFood
//
//  Created by Adam Moore on 5/8/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import CoreML
import Vision


// ****** Info.plist additions:
// *** Need to add "Privacy - Camera Usage Description", with a message when the user is asked to use their camera.
// *** Need to add "Privacy - Photo Library Usage Description", with a message to ask them to user their photos stored on their camera.


// In order for 'UIImagePickerControllerDelegate' to work, it also has to have 'UINavigationControllerDelegate' with it.

// It is View Controller, the UIImagePickerController.

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Image Picker Controller Setup
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    
    // Delegate method that tells the VC that the user has picked an image or movie.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Original image that the user has picked.
        // This is the key for the [String: Any] dictionary that is the 'info' parameter.
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            image.image = userPickedImage
            
            // Convert the 'UIImage' into a 'CIImage', which is a "Core Image Image", which will allow us to use the CoreML and Vision framework to test the image.
            guard let ciimage = CIImage(image: userPickedImage) else {
                
                fatalError("Could not convert to CIImage")
                
            }
            
            // Detect the CIImage with the information and instructions listed below in the 'detect()' function we created.
            detect(image: ciimage)
            
        }
        
        // This dismisses the Image Picker VC, to go back to our main navigation VC.
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        // Create a new model object, using the 'VNCoreMLModel' (from Vision) container for 'Inceptionv3', using its 'model' property loaded up.
        // This new model constant is what we are going to be using to classify our image.
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            
            fatalError("Loading CoreMLModel failed.")
            
        }
        
        // Make a request to the 'VNCoreMLModel'
        let request = VNCoreMLRequest(model: model) { (theRequest, theError) in
            
            // The original results are an array of [Any?], so we are casting it as an array of [VNClassificationObservation], which is a class that holds classification observations.
            guard let results = theRequest.results as? [VNClassificationObservation] else {
                
                fatalError("Model failed to process image.")
                
            }
            
            
            // The 'results' that it comes out with is an array of the different analyses that the computer comes up with to classify the image.
            // The results are in order of confidence, so the first is the most confident description, the second is the next most confident description, etc.
            // There is really not much need for the lesser confidence options for our purposes, so we just get the first result.
            
            // 'results.first' returns the [0] index of the array.
            if let firstResult = results.first {
                
                // 'identifier' checks the actual description of the first element in the classification observations array, the string of description that it produces (not the other confidence percentage information, the numbers, and all the other jazz; just the string), and checks if it contains the string 'hotdog'
                if firstResult.identifier.contains("hotdog") {
                    
                    self.navigationItem.title = "Hotdog!"
                    
                } else {
                    
                    self.navigationItem.title = "Not Hotdog!"
                    
                }
                
            }
            
        }
        
        // Passes the CIImage into 'Vision' to process. The handler then performs a series of requests, in the form of an array, on the image.
        let handler = VNImageRequestHandler(ciImage: image)
        
        // Performs the request that we set above on the image that we pass into the 'VNImageRequestHandler()'
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

