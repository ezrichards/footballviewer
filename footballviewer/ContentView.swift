//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//
//  References:
//  https://www.hackingwithswift.com/forums/swiftui/trigger-action-from-picker/1745
//  https://stackoverflow.com/questions/61668356/onreceive-in-swiftui-view-causes-infinite-loop
//  https://developer.apple.com/documentation/swiftui/binding/wrappedvalue
//  https://stackoverflow.com/questions/60617914/onreceive-string-publisher-lead-to-infinite-loop
//  https://developer.apple.com/documentation/swiftui/building-layouts-with-stack-views
//

import SwiftUI

struct ContentView: View {
    
    var season = 2023 // MARK: TODO maybe have a picker for season or textfield entry?
    @StateObject var viewModel = ViewModel()
    @State private var selection: League? = nil
    @State private var teamOneSelection: Team? = nil
    @State private var teamTwoSelection: Team? = nil
    @State private var teamOnePlayers: [Players]?
    @State private var teamTwoPlayers: [Players]?
    @State private var selectedPlayerOne: Int? = nil
    @State private var selectedPlayerTwo: Int? = nil
    @State private var playerOne: Players? = nil
    @State private var playerTwo: Players? = nil
    // MARK: TODO for stat view
    @State private var playerOneTest: PlayerJson? = nil
    @State private var playerTwoTest: PlayerJson? = nil
    
    var body: some View {
        VStack {
            HSplitView {
                VStack {
                    if let leagueJson = viewModel.leagues {
                        if let response = leagueJson.response {
                            // reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                            // reference: https://stackoverflow.com/questions/72513176/swiftui-picker-doesnt-show-selected-value
                            // reference: https://stackoverflow.com/questions/57518852/swiftui-picker-onchange-or-equivalent
                            Picker("Select a league:", selection: $selection) {
                                ForEach(response) { response in
                                    if let countryName = response.country?.name {
                                        Text("\(response.league?.name ?? "undefined") (\(countryName))").tag(response.league)
                                    }
                                }
                            }
                            .frame(maxWidth: 250)
                            .pickerStyle(.menu)
                            .onChange(of: selection) {
                                Task {
                                    await viewModel.loadTeams(withLeagueId: selection?.id! ?? 0, withSeasonId: season)
                                }
                            }
//                            if let selection = selection, let name = selection.name {
//                                Text("Selected league: \(name)")
//                            }
                        }
                        
                        Text("Teams")
                        if let squads: SquadJson = viewModel.squads {
                            if let response = squads.response {
                                ScrollView {
                                    ForEach(response) { squad in
                                        if let team = squad.team {
                                            Text(team.name ?? "undefined")
                                        }
                                    }
                                }
                                HStack {
                                    VStack {
                                        // MARK: team 1 selection
                                        Picker("Team One:", selection: $teamOneSelection) {
                                            ForEach(response) { response in
                                                if let team = response.team {
                                                    Text(team.name ?? "undefined").tag(response.team)
                                                }
                                            }
                                        }
                                        .frame(maxWidth: 200)
                                        .pickerStyle(.menu)
                                        .onChange(of: teamOneSelection) {
                                            Task {
                                                teamOnePlayers = await viewModel.loadSquad(teamId: teamOneSelection?.id ?? 0)
                                            }
                                        }
                                        
                                        if let players = teamOnePlayers {
                                            ScrollView {
                                                ForEach(players) { player in
                                                    if let name = player.name, let number = player.number {
                                                        // MARK: TODO add player numbers to dropdowns
                                                        Text("\(name) (\(number))").tag(player.id)
                                                    }
                                                }
                                            }
                                            
                                            // player one selection
                                            Picker("Player One:", selection: $selectedPlayerOne) {
                                                ForEach(players) { player in
                                                    if let name = player.name, let number = player.number {
                                                        // MARK: TODO add player numbers to dropdowns
                                                        Text("\(name) (\(number))").tag(player.id)
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: 200)
                                            .pickerStyle(.menu)
                                            .onChange(of: selectedPlayerOne) { oldValue, newValue in
                                                playerOne = teamOnePlayers?.first(where: { $0.id == selectedPlayerOne })
                                                
                                                if let playerId = playerOne?.id {
                                                    Task {
                                                        playerOneTest = await viewModel.loadPlayerById(withId: playerId, withSeasonId: season)
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    VStack {
                                        // MARK: team 2 selection
                                        Picker("Team Two:", selection: $teamTwoSelection) {
                                            ForEach(response) { response in
                                                if let team = response.team {
                                                    Text(team.name ?? "undefined").tag(response.team)
                                                }
                                            }
                                        }
                                        .frame(maxWidth: 200)
                                        .pickerStyle(.menu)
                                        .onChange(of: teamTwoSelection) {
                                            Task {
                                                teamTwoPlayers = await viewModel.loadSquad(teamId: teamTwoSelection?.id ?? 0)
                                            }
                                        }

                                        if let players = teamTwoPlayers {
                                            ScrollView {
                                                ForEach(players) { player in
                                                    if let name = player.name, let number = player.number {
                                                        // MARK: TODO add player numbers to dropdowns
                                                        Text("\(name) (\(number))").tag(player.id)
                                                    }
                                                }
                                            }
                                            
                                            // player two selection
                                            Picker("Player Two:", selection: $selectedPlayerTwo) {
                                                ForEach(players) { player in
                                                    if let name = player.name, let number = player.number {
                                                        // MARK: TODO add player numbers to dropdowns
                                                        Text("\(name) (\(number))").tag(player.id)
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: 200)
                                            .pickerStyle(.menu)
                                            .onChange(of: selectedPlayerTwo) { oldValue, newValue in
                                                playerTwo = teamTwoPlayers?.first(where: { $0.id == selectedPlayerTwo })
                                                
                                                if let playerId = playerTwo?.id {
                                                    Task {
                                                        playerTwoTest = await viewModel.loadPlayerById(withId: playerId, withSeasonId: season)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    

                                }
                            }
                        }
 
                    }
    //            GraphView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                
                // MARK: player one info
                VStack {
                    if let playerOne = playerOneTest, let response = playerOne.response?.first, let statistics = response.statistics {
//                        Text("\(response)")
                        
                        if let player = response.player, let photo = player.photo {
                            // reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-load-a-remote-image-from-a-url
                            AsyncImage(url: URL(string: photo))
                            Text("\(player.name!)")
                            Text("\(player.age!)")
                            Text("\(player.nationality!)")
                        }
                        
                        ForEach(statistics) { statistic in
                            ScrollView {
                                Text("\(statistic.games?.appearences)")
                                Text("\(statistic.games?.rating)")
                            }
                            
//                            if let games = statistic.games {
//                            Text("Appearances: \(statistic.games?.appearences)")
//                            Text("Position: \(statistic.games.position)")
//                            Text("Average Rating: \(statistic.games.rating)")
//                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // MARK: player two info
                VStack {
                    if let playerTwo = playerTwoTest, let response = playerTwo.response?.first, let statistics = response.statistics {
//                        Text("\(response)")
                        
                        if let player = response.player, let photo = player.photo {
                            // reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-load-a-remote-image-from-a-url
                            AsyncImage(url: URL(string: photo))
                            Text("\(player.name!)")
                            Text("\(player.age!)")
                            Text("\(player.nationality!)")
                        }
                        
                        ForEach(statistics) { statistic in
                            ScrollView {
                                Text("\(statistic.games?.appearences)")
                                Text("\(statistic.games?.rating)")
                            }
                            
//                            if let games = statistic.games {
//                            Text("Appearances: \(statistic.games?.appearences)")
//                            Text("Position: \(statistic.games.position)")
//                            Text("Average Rating: \(statistic.games.rating)")
//                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
