//
//  FaceCropViewController.swift
//  Face Detection
//
//  Created by Chen Shen and Yiming Pan  on 4/9/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//  Reference: https://developer.apple.com/documentation/vision/vntextobservation

import UIKit
import AVFoundation
import Vision

class FaceCropViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var myImageView: UIImageView!
    var imagePicked = UIImage(named: "image.jpg")!
    
    @IBAction func `import`(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //Pick photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            myImageView.image = image
            imagePicked = image
        }else{
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function that adds rectangles to text in picture
    func addRectangles(forObservations observations: [VNTextObservation]) {
        if let layers = self.myImageView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: imagePicked.size, insideRect: myImageView.bounds)
        // Add rectangle boxes for different layers of text found
        let layers: [CAShapeLayer] = observations.map { observation in
            //width, height, x, y setup
            let width = imageRect.width * observation.boundingBox.size.width
            let height = imageRect.height * observation.boundingBox.size.height
            let x = observation.boundingBox.origin.x * imageRect.width + imageRect.origin.x
            let y = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - height
            
            //Layer parameters setup
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: x , y: y, width: width, height: height)
            layer.borderWidth = 3
            layer.cornerRadius = 5
            layer.borderColor = UIColor.blue.cgColor
            
            return layer
        }
        
        //Do for all layers
        for layer in layers {
            myImageView.layer.addSublayer(layer)
        }
    }
    
    @IBAction func Findtext(_ sender: UIButton) {
        //Send a request to detect text
        let textDetectionRequest = VNDetectTextRectanglesRequest(completionHandler: {(request, error) in
            guard let observe = request.results as? [VNTextObservation]
                else { fatalError("Unexpected result") }
            self.addRectangles(forObservations: observe)
        })
        //Request Handler
        let handler = VNImageRequestHandler(cgImage: imagePicked.cgImage!, options: [:])
        guard let _ = try? handler.perform([textDetectionRequest])
            else {
            return print("Request cannot be performed")
        }
    }
    
}
