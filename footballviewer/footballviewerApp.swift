//
//  footballviewerApp.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

@main
struct footballviewerApp: App {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        
        Settings {
            PreferencesView(viewModel: viewModel)
                .padding()
        }
    }
}
