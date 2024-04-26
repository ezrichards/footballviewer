//
//  TableView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/26/24.
//

import SwiftUI

struct TableView: View {
    
    var players: [PlayerResponse]
    
    var body: some View {
        Text("Hello, World!")

        Table(players) {
            TableColumn("Name", value: \.player.name!)
            TableColumn("Age") {
                Text(String(describing: $0.player.age!))
            }
        }

    }
}
