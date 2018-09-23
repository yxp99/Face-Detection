//
//  NameTable.swift
//  Face Detection
//
//  Created by Chen Shen and Yiming Pan  on 5/2/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//

import UIKit

var secondIndex:[String] = []
var myIndex2 = 0

class NameTable: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        secondIndex = FaceData.getNamelist()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return secondIndex.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.text = secondIndex[indexPath.row]
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex2 = indexPath.row
        performSegue(withIdentifier: "seg2",sender:self)
    }

}
