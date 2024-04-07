//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!").padding()
            
            Button("Query Players") {
                
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

