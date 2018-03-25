//
//  HeroModelClass.swift
//  SQlite-Practise
//
//  Created by MySoftheaven BD on 25/3/18.
//  Copyright © 2018 MySoftheaven BD. All rights reserved.
//

import Foundation


class Hero {
    var id : Int
    var name : String?
    var powerrank : Int
    
    init(id: Int, name: String?, powerrank: Int) {
        self.id = id
        self.name = name
        self.powerrank = powerrank
    }
}
