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
            
        }
        
        // This dismisses the Image Picker VC, to go back to our main navigation VC.
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
}

