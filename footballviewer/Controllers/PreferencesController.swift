//
//  PreferencesController.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/6/24.
//

import Foundation
import Observation

@Observable
class PreferencesController {
    var apiKey: String {
        didSet {
            save(withKey: apiKey)
        }
    }
    
//    save league settings after last one
    
    init() {
        self.apiKey = UserDefaults.standard.value(forKey: UserDefaults.apiKey) as? String ?? ""
    }
    
    func save(withKey key: String) {
         UserDefaults.standard.setValue(key, forKey: UserDefaults.apiKey)
     }
     
}
