//
//  GraphView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/10/24.
//

import SwiftUI

struct GraphView: View {
    
    @State private var playerOne = ""
    @State private var playerTwo = ""
    
    var body: some View {
        VStack {
            Text("Player One Selection: \(playerOne)")
            Text("Player Two Selection: \(playerTwo)")
        }
    }
}
