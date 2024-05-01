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
    
    @State private var searchText = ""
    
    var filteredPlayers: [PlayerResponse] {
        guard !searchText.isEmpty else { return players }
        
        var filteredPlayers: [PlayerResponse] = []
        for player in players {
            if let name = player.player.name {
                if name.lowercased().contains(searchText.lowercased()) {
                    filteredPlayers.append(player)
                }
            }
        }
        return filteredPlayers
    }
    
    @Binding var selectedPlayers: Set<PlayerResponse.ID>
    
    var body: some View {
        List(selection: $selectedPlayers) {
            Section(header: Text("Players")) {
                ForEach(filteredPlayers, id: \.id) { player in
                    Text(player.player.name ?? "")
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search players..")
        .padding()
        .frame(maxHeight: 300)
    }
}
