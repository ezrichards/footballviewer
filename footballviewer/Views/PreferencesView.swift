//
//  PreferencesView.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/6/24.
//

import SwiftUI

struct PreferencesView: View {

    var viewModel: ViewModel
    
    @State var preferencesController = PreferencesController()
    
    var body: some View {
        VStack {
//            Button("Re-fetch leagues") {
//                Task {
//                    await viewModel.loadLeagues()
//                }
//            }
//            .padding()
            
            Text("API Key")
            TextField("apiKey", text: $preferencesController.apiKey)
            
            Text("Season")
            TextField("season", value: $preferencesController.season, formatter: NumberFormatter())
        }
        .padding()
    }
}
