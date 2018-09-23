//
//  DetailController.swift
//  Face Detection
//
//  Created by cj on 5/2/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var idText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idText.text = String(FaceData.getMember(seq: myIndex2).ID)
        dateText.text = String(FaceData.getMember(seq: myIndex2).Date)
        nameText.text = String(FaceData.getMember(seq: myIndex2).Name)
        myImageView.image = FaceData.getMember(seq: myIndex2).faceImage
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}
