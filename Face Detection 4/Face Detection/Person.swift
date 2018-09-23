//
//  Person.swift
//  Face Detection
//
//  Created by Chen Shen and Yiming Pan  on 5/2/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//

import Foundation
import UIKit


//var image1: UIImage? = nil

class Person {
    var ID: String
    var Name: String
    var Date:String
    var faceImage: UIImage
    
    init(ID:String, Date:String, Name:String,faceImage:UIImage){
        self.ID = ID
        self.Name = Name
        self.Date = Date
        self.faceImage = faceImage
    }
    
}
