//
//  StateManager.swift
//  Match Game 3
//
//  Created by Ara Apoyan on 9/13/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import Foundation

struct StateManager {
    
    static var millisecondKey = "millisecondKey"
    
    static func saveMillData(millisecond: Double, key: String) {
        UserDefaults.standard.set(millisecond, forKey: key)
    }
    
    static func loadMillData(key: String) -> Any? {
       return UserDefaults.standard.value(forKeyPath: key)
    }
    
    static func deleteMillData(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

