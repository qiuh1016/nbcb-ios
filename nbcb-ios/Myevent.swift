//
//  Myevent.swift
//  nbcb-ios
//
//  Created by qiuhong on 07/07/2017.
//  Copyright © 2017 qh. All rights reserved.
//

import Foundation

class Myevent {
    var title: String
    var finished: Int
    var id: Int
    
    init(title: String, id: Int, finished: Int) {
        self.title = title
        self.id = id
        self.finished = finished
    }
}
