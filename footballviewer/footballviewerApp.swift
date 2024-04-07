//
//  footballviewerApp.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

@main
struct footballviewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        Settings {
            PreferencesView()
        }
    }
}
