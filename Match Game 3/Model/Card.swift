//
//  Card.swift
//  Match Game 3
//
//  Created by Ara Apoyan on 7/30/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import Foundation


struct Card: Equatable {
    var imageName: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
    
    // private var number: Int

//    static var identifer = 0
//    
//    static func getUnqiqueIdentifer() -> Int {
//        self.identifer += 1
//        return identifer
//    }
//    
    init(imageName: String) {
        self.imageName = imageName
       // self.number = Card.getUnqiqueIdentifer()
    }
 
    static func ==(leftCard: Card, rightCard: Card) -> Bool {
        return leftCard.imageName == rightCard.imageName
    }
}
