//
//  FaceList.swift
//  Face Detection
//
//  Created by Chen Shen and Yiming Pan  on 5/2/18.
//  Copyright © 2018 EECS 392. All rights reserved.
//

import Foundation
class FaceList {
    var member: [Person] = []

    func add(child: Person) {
        member.append(child)
        //member.parent = self
    }
    
    init(member:[Person]){
        self.member = member
    }
    
//    func getProband()->String{
//        return proband.lastName
//    }
    
    func getNamelist()->Array<String>{
        var list: [String] = []
        for n in member {
            list.append(n.Name)
        }
        return list
    }
    
    func getMember(seq:Int)->Person{
        return member[seq]
    }
}
