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
    
    var lastLeagues: [League.ID] {
        didSet {
            saveLastLeagues()
        }
    }
    
    var season: Int {
        didSet {
            saveSeason()
        }
    }
    
    init() {
        self.apiKey = UserDefaults.standard.value(forKey: UserDefaults.apiKey) as? String ?? ""
        self.lastLeagues = UserDefaults.standard.value(forKey: UserDefaults.lastLeagues) as? [League.ID] ?? []
        self.season = UserDefaults.standard.value(forKey: UserDefaults.season) as? Int ?? 2023
    }

    func save(withKey key: String) {
        UserDefaults.standard.setValue(key, forKey: UserDefaults.apiKey)
    }
    
    func saveLastLeagues() {
        UserDefaults.standard.setValue(lastLeagues, forKey: UserDefaults.lastLeagues)
    }
    
    func saveSeason() {
        UserDefaults.standard.setValue(season, forKey: UserDefaults.season)
    }
}
