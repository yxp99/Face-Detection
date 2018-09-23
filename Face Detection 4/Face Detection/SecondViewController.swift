//
//  SecondViewController.swift
//  Face Detection
//
//  Created by Chen Shen and Yiming Pan  on 4/8/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//
// OFFICIAL REFERENCE: https://developer.apple.com/documentation/coreimage/cifacefeature
//and https://developer.apple.com/documentation/vision


import UIKit
import Vision

class SecondViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    
    var TransferImage: UIImage!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.image = TransferImage
        image = TransferImage
        detect()
        // Do any additional setup after loading the view.
    }


    func detect()
    {
        //Get image from image view
        let myImage = CIImage(image: myImageView.image!)!
        
        //Set up the detecor
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options: [CIDetectorSmile:true])
        
        if !faces!.isEmpty
        {
            for face in faces as! [CIFaceFeature]
            {
                let moutShowing = "\nMouth is showing: \(face.hasMouthPosition)"
                let isSmiling = "\nPerson is smiling: \(face.hasSmile)"
                var bothEyesShowing = "\nBoth eyes showing: true"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyesShowing = "\nBoth eyes showing: false"
                }
                
                //Degree of suspiciousness
                let array = ["Low", "Medium", "High", "Very high"]
                var suspectDegree = 0
                
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile {suspectDegree += 1}
                if bothEyesShowing.contains("false") {suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                
                let suspectText = "\nSuspiciousness: \(array[suspectDegree])"
                
                myTextView.text = "\(suspectText) \n\(moutShowing) \(isSmiling) \(bothEyesShowing)"
            }
        }
        else
        {
            myTextView.text = "No faces found"
        }
    }
    
    @IBAction func process(_ sender: UIButton){
        //A request to add face landmark to Vision
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures)
        //A handler for the request
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage! ,options: [:])
        
        do {
            try requestHandler.perform([faceLandmarksRequest])
        }
        catch {
            print("Error")
        }
    }

    func handleFaceFeatures(request: VNRequest, errror: Error?) {
        //If type unexpected, throw an error
        guard let find = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
        
        //Add landmarks for all faces found in picture
        for face in find {
            addFaceLandmarks(face)
            print("Face Found")
        }
    }
    
    //Add landmarks to different parts of face
    //faceContext?.setLineWidth(8.0)        --> set the drawing line's width
    //faceContext?.drawPath(using: .stroke) --> set the path drawing way
    //faceContext?.saveGState()             --> save current state of landmarks
    //faceContext?.setStrokeColor(UIColor.yellow.cgColor)  --> set the color of drawing
    //faceContext?.closePath()              --> make the drawing of face component closed
    func addFaceLandmarks(_ face: VNFaceObservation) {
        
        // Context of the graph, start drawing
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let faceContext = UIGraphicsGetCurrentContext()
        
        // prepare to draw on the image
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    
        faceContext?.scaleBy(x: 1.0, y: -1.0)
        faceContext?.translateBy(x: 0, y: image.size.height)
        
        // draw the face rect
        let x = face.boundingBox.origin.x * image.size.width
        let y = face.boundingBox.origin.y * image.size.height
        let width = face.boundingBox.size.width * image.size.width
        let height = face.boundingBox.size.height * image.size.height
        
        // Outline of face ( doesn't need to be close line )
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.green.cgColor)
        if let landmark = face.landmarks?.faceContour {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // left eye
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // right eye
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // left pupil
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // right pupil
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // left eyebrow ( doesn't need to be close line )
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // right eyebrow ( doesn't need to be close line )
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // nose
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.nose {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // nose crest ( doesn't need to be close line )
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.noseCrest {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // outer lips
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.red.cgColor)
        if let landmark = face.landmarks?.outerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // inner lips
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.red.cgColor)
        if let landmark = face.landmarks?.innerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.closePath()
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()

        // median line ( doesn't need to be close line )
        faceContext?.saveGState()
        faceContext?.setStrokeColor(UIColor.blue.cgColor)
        if let landmark = face.landmarks?.medianLine {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    faceContext?.move(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
                else {
                    faceContext?.addLine(to: CGPoint(x: x + CGFloat(point.x) * width, y: y + CGFloat(point.y) * height))
                }
            }
        }
        faceContext?.setLineWidth(8.0)
        faceContext?.drawPath(using: .stroke)
        faceContext?.saveGState()
        
        // get the final image
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // end drawing context
        UIGraphicsEndImageContext()
        myImageView.image = result
    }
}
