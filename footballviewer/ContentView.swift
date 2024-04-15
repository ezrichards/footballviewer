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
    @State private var toggled: Bool = false
    @State private var teamTwoToggled: Bool = false
    @State private var teamOnePlayers: [Players]?
    @State private var teamTwoPlayers: [Players]?
    
    @State private var selectedPlayerOne: Int? = nil
    @State private var selectedPlayerTwo: Int? = nil
    
    // stat players from viewmodel
    @State private var playerOne: Players? = nil
    @State private var playerTwo: Players? = nil
    
    // MARK: TODO testing for stats
    @State private var playerOneTest: PlayerJson? = nil
    
    var body: some View {
        VStack {
            HSplitView {
                VStack {
                    Text("Leagues")
                    if let leagueJson = viewModel.leagues {
                        if let response = leagueJson.response {
                            // reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                            // reference: https://stackoverflow.com/questions/72513176/swiftui-picker-doesnt-show-selected-value
                            // reference: https://stackoverflow.com/questions/57518852/swiftui-picker-onchange-or-equivalent
                            Picker("", selection: $selection) {
                                ForEach(response) { response in
                                    if let countryName = response.country?.name {
                                        Text("\(response.league?.name ?? "undefined") (\(countryName))").tag(response.league)
                                    }
                                }
                            }
                            .frame(maxWidth: 200)
                            .pickerStyle(.menu)
                            .onChange(of: selection) {
                                Task {
                                    await viewModel.loadTeams(withLeagueId: selection?.id! ?? 0, withSeasonId: season)
                                }
                            }
                            
                            if let selection = selection, let name = selection.name {
                                Text("Selected league: \(name)")
                            }
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
                                
                                // team 1 selection
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
                                    // MARK: TODO fix others to use onChange
    //                                toggled.toggle()
                                    Task {
                                        teamOnePlayers = await viewModel.loadSquad(teamId: teamOneSelection?.id ?? 0)
    //                                    selectedPlayerOne = teamOnePlayers![0]
                                    }
                                }
    //                            .onReceive([self.$teamOneSelection].publisher.first()) { newValue in
    //                                if toggled {
    //                                    Task {
    //                                        teamOnePlayers = await viewModel.loadSquad(teamId: teamOneSelection?.id ?? 0)
    //                                    }
    //                                    toggled.toggle()
    //                                }
    //                            }
                                
                                if let players = teamOnePlayers {
                                    ScrollView {
                                        ForEach(players) { player in
                                            Text(player.name ?? "undefined")
                                        }
                                    }
                                    
                                    // player one selection
                                    Picker("Player One:", selection: $selectedPlayerOne) {
                                        ForEach(players) { player in
                                            if let name = player.name {
                                                // MARK: TODO add player numbers to dropdowns
                                                Text("\(name)").tag(player.id)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: 200)
                                    .pickerStyle(.menu)
                                    .onChange(of: selectedPlayerOne) { oldValue, newValue in
    //                                    print("OLD:", oldValue)
    //                                    print("NEW:", newValue)
                                        
                                        playerOne = teamOnePlayers?.first(where: { $0.id == selectedPlayerOne })
                                        
                                        if let playerId = playerOne?.id {
                                            Task {
                                                playerOneTest = await viewModel.loadPlayerById(withId: playerId, withSeasonId: season)
                                            }
                                        }
                                    }
                                }
                                
                                // team 2 selection
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
                                    teamTwoToggled.toggle()
                                }
                                .onReceive([self.$teamTwoSelection].publisher.first()) { newValue in
                                    if teamTwoToggled {
                                        Task {
                                            teamTwoPlayers = await viewModel.loadSquad(teamId: teamTwoSelection?.id ?? 0)
                                        }
                                        teamTwoToggled.toggle()
                                    }
                                }
                                
                                if let players = teamTwoPlayers {
                                    ScrollView {
                                        ForEach(players) { player in
                                            Text(player.name ?? "undefined")
                                        }
                                    }
                                }
                            }
                        }
                    }
    //            GraphView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray)
                
                VStack {
                    if let playerOne = playerOneTest, let response = playerOne.response?.first, let statistics = response.statistics {
                        Text("\(response)")
                        
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

//                    if let playerOneTest = playerOneTest, let response = playerOneTest.response, let statistics = response[0].statistics {
//                        
//                        ForEach((statistics) { statistic in
//                            Text("\(statistic.games)")
//                            if let games = statistic.games {
//                                Image(URL(string: playerOneTest?.response?.first.player?.photo))
//                                Text("Appearances:", games.appearences)
//                                Text("Position:", games.position)
//                                Text("Average Rating:", games.rating)
//                            }
//                        }
//                    }
                    
                    
//                    if let stats = playerOneTest?.response?.first? {
//                        ForEach(stats.statistics) { statistic in
//                            if let games = statistic.games {
//                                Image(URL(string: playerOneTest?.response?.first.player?.photo))
//                                Text("Appearances:", games.appearences)
//                                Text("Position:", games.position)
//                                Text("Average Rating:", games.rating)
//                            }
//                        }
//                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
