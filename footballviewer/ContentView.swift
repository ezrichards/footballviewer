//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationSplitView {
            VStack {
                LeagueView(viewModel: viewModel, selectedLeagues: $viewModel.leagueSelection, leagues: viewModel.leagues)

                TeamView(viewModel: viewModel, selectedTeams: $viewModel.teamSelection, leagues: viewModel.leagues, teams: viewModel.teams)

                PlayerView(viewModel: viewModel, players: viewModel.players, selectedPlayers: $viewModel.selectedPlayers)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } content: {
            TableView(viewModel: viewModel, players: viewModel.selectedPlayersTable)
        } detail: {
            DetailView(viewModel: viewModel, player: viewModel.player)
        }
    }
}
