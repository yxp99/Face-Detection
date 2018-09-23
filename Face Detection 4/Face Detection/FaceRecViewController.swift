//
//  FaceRecViewController.swift
//  Face Detection
//
//  Created by cj on 4/9/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//

import UIKit
import Vision
//import FacebookShare

//let a = Person(ID: "cd", Name: "fd")
//var FaceData = FaceList(member: [a])
var FaceData = FaceList(member:[])
//var thisImage = CIImage(image: myImageView.image!)!
var thisImage = UIImage()

class FaceRecViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func `import`(_ sender: Any) {
        //Create image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //display the image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addData(_ sender: Any) {
       // thisImage = CIImage(image: myImageView.image!)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Pick photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //myImageView.image = image
            thisImage = image
            Recognize(uiimage: image)
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }

    func Recognize(uiimage:UIImage){
        
        let imageView = UIImageView(image: uiimage)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / uiimage.size.width * uiimage.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        imageView.backgroundColor = .blue
        
        //Addd the image onto the view 
        view.addSubview(imageView)
        
        //SEND FACE DETECTION REQUEST HERE.
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
        //FOR EACH FACE DETECTED, DO SUCH.
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeight * faceObservation.boundingBox.height
                    
                    let y = scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
                    
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                }
            })
        }
        
        guard let cgImage = uiimage.cgImage else { return }

        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }

}
