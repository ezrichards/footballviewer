//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//  References:
//  Dr. Hildreth lecture on InspectorView
//  https://github.com/OHildreth/Image_inClass2024/blob/main/Image_inClass2024/ContentView.swift
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel
    
    @AppStorage("visibility_inspector") private var visibility_inspector = true
    
    var body: some View {
        NavigationSplitView {
            VStack {
                LeagueView(viewModel: viewModel, leagues: viewModel.leagues, selectedLeagues: $viewModel.leagueSelection)

                TeamView(viewModel: viewModel, selectedTeams: $viewModel.teamSelection, leagues: viewModel.leagues, teams: viewModel.teams)

                PlayerView(viewModel: viewModel, players: viewModel.players, selectedPlayers: $viewModel.selectedPlayers)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } detail: {
            TableView(viewModel: viewModel, players: viewModel.selectedPlayersTable, selection: $viewModel.playerSelection)
        }.inspector(isPresented: $visibility_inspector) {
            DetailView(viewModel: viewModel, player: viewModel.player)
                .padding()
                .frame(maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(id: "inspector") {
                        Button {
                            visibility_inspector.toggle()
                        } label: {
                            Image(systemName: "sidebar.right")
                        }
                    }
                }
        }
    }
}
