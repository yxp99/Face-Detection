//
//  addFormController.swift
//  Face Detection
//
//  Created by Chen Shen and Yiming Pan on 5/2/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//

import UIKit
import Vision

class addFormController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var idText: UITextField!
    
    @IBOutlet weak var dateText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clickSubmit(_ sender: UIButton) {
        //let newPerson = Person(ID: idText.text!, Name: nameText.text!,faceImage:thisImage)
        let newPerson = Person(ID:idText.text!, Date: dateText.text!, Name: nameText.text!, faceImage: thisImage)
        FaceData.add(child: newPerson)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
