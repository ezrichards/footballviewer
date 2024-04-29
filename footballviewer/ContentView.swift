//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//
//  References:
//   https://stackoverflow.com/questions/60617914/onreceive-string-publisher-lead-to-infinite-loop
//  https://developer.apple.com/documentation/swiftui/building-layouts-with-stack-views
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
//  https://stackoverflow.com/questions/72513176/swiftui-picker-doesnt-show-selected-value
//  https://stackoverflow.com/questions/57518852/swiftui-picker-onchange-or-equivalent
//  https://stackoverflow.com/questions/59348093/picker-for-optional-data-type-in-swiftui
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-load-a-remote-image-from-a-url
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-allow-row-selection-in-a-list
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel
    @State var preferencesController = PreferencesController()

    @State private var selectedPlayerOne: Int? = nil
    @State private var selectedPlayerTwo: Int? = nil
    @State private var playerOne: Players? = nil
    @State private var playerTwo: Players? = nil
    @State private var playerOneTest: PlayerJson? = nil
    @State private var playerTwoTest: PlayerJson? = nil

    var body: some View {
        NavigationSplitView {
            VStack {
                LeagueView(viewModel: viewModel, selectedLeagues: $viewModel.leagueSelection, leagues: viewModel.leagues)

                TeamView(viewModel: viewModel, selectedTeams: $viewModel.teamSelection, leagues: viewModel.leagues, teams: viewModel.teams)

                PlayerView()
                
//                    Text("Teams")
//                    if let squads = viewModel.squads, let response = squads.response {
//                        ScrollView {
//                            ForEach(response) { squad in
//                                if let team = squad.team {
//                                    Text(team.name ?? "undefined")
//                                }
//                            }
//                        }
//                        HStack {
//                            VStack {
//                                // MARK: team 1 selection
//                                Picker("Team One:", selection: $viewModel.teamOneSelection) {
//                                    ForEach(response) { response in
//                                        if let team = response.team {
//                                            Text(team.name ?? "undefined").tag(response.team)
//                                        }
//                                    }
//                                }
//                                .frame(maxWidth: 200)
//                                .pickerStyle(.menu)
//
//                                if let players = viewModel.teamOnePlayers {
//                                    ScrollView {
//                                        ForEach(players) { player in
//                                            if let name = player.name, let number = player.number {
//                                                // MARK: TODO add player numbers to dropdowns
//                                                Text("\(name) (\(number))").tag(player.id)
//                                            }
//                                        }
//                                    }
//
//                                    // player one selection
//                                    Picker("Player One:", selection: $selectedPlayerOne) {
//                                        ForEach(players) { player in
//                                            if let name = player.name, let number = player.number {
//                                                // MARK: TODO add player numbers to dropdowns
//                                                Text("\(name) (\(number))").tag(player.id)
//                                            }
//                                        }
//                                    }
//                                    .frame(maxWidth: 200)
//                                    .pickerStyle(.menu)
//                                    .onChange(of: selectedPlayerOne) { oldValue, newValue in
//                                        playerOne = viewModel.teamOnePlayers?.first(where: { $0.id == selectedPlayerOne })
//
//                                        if let playerId = playerOne?.id {
//                                            Task {
//                                                playerOneTest = await viewModel.loadPlayerById(withId: playerId, withSeasonId: 2023)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//
//                            VStack {
//                                // MARK: team 2 selection
//                                Picker("Team Two:", selection: $viewModel.teamTwoSelection) {
//                                    ForEach(response) { response in
//                                        if let team = response.team {
//                                            Text(team.name ?? "undefined").tag(response.team)
//                                        }
//                                    }
//                                }
//                                .frame(maxWidth: 200)
//                                .pickerStyle(.menu)
//
//                                if let players = viewModel.teamTwoPlayers {
//                                    ScrollView {
//                                        ForEach(players) { player in
//                                            if let name = player.name, let number = player.number {
//                                                // MARK: TODO add player numbers to dropdowns
//                                                Text("\(name) (\(number))").tag(player.id)
//                                            }
//                                        }
//                                    }
//
//                                    // player two selection
//                                    Picker("Player Two:", selection: $selectedPlayerTwo) {
//                                        ForEach(players) { player in
//                                            if let name = player.name, let number = player.number {
//                                                // MARK: TODO add player numbers to dropdowns
//                                                Text("\(name) (\(number))").tag(player.id)
//                                            }
//                                        }
//                                    }
//                                    .frame(maxWidth: 200)
//                                    .pickerStyle(.menu)
//                                    .onChange(of: selectedPlayerTwo) { oldValue, newValue in
//                                        playerTwo = viewModel.teamTwoPlayers?.first(where: { $0.id == selectedPlayerTwo })
//
//                                        if let playerId = playerTwo?.id {
//                                            Task {
//                                                playerTwoTest = await viewModel.loadPlayerById(withId: playerId, withSeasonId: 2023)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        } content: {
            TableView(viewModel: viewModel, players: viewModel.players)
        } detail: {
            DetailView(viewModel: viewModel, player: viewModel.player)
        }
    }
}
