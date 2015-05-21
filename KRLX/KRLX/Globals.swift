//
//  Globals.swift
//  KRLX
//
//  Created by Josie Bealle and Phuong Dinh on 19/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
import UIKit


class Singleton {
    var loadedArticleHeaders : NSMutableArray
    init() {
        loadedArticleHeaders = NSMutableArray()

    }
    
}
let sharedData = Singleton()