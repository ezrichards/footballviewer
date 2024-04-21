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
    
    var lastLeague: Int {
        didSet {
            saveLastLeague()
        }
    }
    
    init() {
        self.apiKey = UserDefaults.standard.value(forKey: UserDefaults.apiKey) as? String ?? ""
        self.lastLeague = UserDefaults.standard.value(forKey: UserDefaults.lastLeague) as? Int ?? 0
    }
    
    func save(withKey key: String) {
        UserDefaults.standard.setValue(key, forKey: UserDefaults.apiKey)
    }
    
    func saveLastLeague() {
        UserDefaults.standard.setValue(lastLeague, forKey: UserDefaults.lastLeague)
    }
}
