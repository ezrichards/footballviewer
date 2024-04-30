//
//  PlayerView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/29/24.
//

import SwiftUI

struct PlayerView: View {
    var viewModel: ViewModel
    
    var players: [PlayerResponse]
    
    @Binding var selectedPlayers: Set<PlayerResponse.ID>
    
    var body: some View {
        List(selection: $selectedPlayers) {
            Section(header: Text("Players")) {
                ForEach(players, id: \.id) { player in
                    Text(player.player.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxHeight: 300)
    }
}
