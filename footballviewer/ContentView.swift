//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

struct ContentView: View {

    let viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Button("Query Players") {
                Task {
                    await viewModel.loadLeagues()
                }
            }
            Button("Query Teams") {
                
            }
            Button("Query Leagues") {
                
            }
            
            VSplitView {
                Text("Detail View").padding()
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
    }
}

