//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//
//  References:
//  https://www.hackingwithswift.com/forums/swiftui/trigger-action-from-picker/1745
//  https://stackoverflow.com/questions/60617914/onreceive-string-publisher-lead-to-infinite-loop
//  https://developer.apple.com/documentation/swiftui/building-layouts-with-stack-views
//

import SwiftUI

struct ContentView: View {
    
    var season = 2023 // MARK: TODO maybe have a picker for season or textfield entry?
    @StateObject var viewModel = ViewModel()
    @State var preferencesController = PreferencesController()
    
//    func getLeagueById(_ id: String) -> League? {
//        return viewModel.leagues?.response?.first(where: { $0.league?.id == Int(id) })
//    }
    
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
                            .onChange(of: selection) { // MARK: TODO put this under didSet on a viewmodel
                                Task {
                                    await viewModel.loadTeams(withLeagueId: selection?.id! ?? 0, withSeasonId: season)
                                }
                                print("LAST LEAGUE:", preferencesController.lastLeague)
                                preferencesController.saveLastLeague(withId: selection?.id ?? 0)
                            }
                            
//                            if let selection = selection, let name = selection.name {
//                                Text("Selected league: \(name)")
//                                AsyncImage(url: URL(string: selection.logo!))
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
                            Text("Age: \(player.age!)")
                            Text("Nationality: \(player.nationality!)")
                        }
                        
                        ForEach(statistics) { statistic in
                            if statistic.league?.id == selection?.id {
                                
                                Text("General Statistics").bold()
                                ScrollView {
                                    if let games = statistic.games, let rating = games.rating, let appearances = games.appearences, let position = games.position {
                                        Text("Appearances: \(appearances)")
                                        Text("Average Rating: \(rating)")
                                        Text("Position: \(position)")
                                    }
                                }
                                
                                Text("Goals/Assists").bold()
                                ScrollView {
                                    if let goals = statistic.goals, let total = goals.total, let assists = goals.assists {
                                        Text("Goals: \(total)")
                                        Text("Assists: \(assists)")
                                    }
                                }
                                
                                Text("Passes").bold()
                                ScrollView {
                                    if let passes = statistic.passes, let total = passes.total, let key = passes.key, let accuracy = passes.accuracy {
                                        Text("Total: \(total)")
                                        Text("Key Passes: \(key)")
                                        Text("Accuracy: \(accuracy)%")
                                    }
                                }
                            }
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
                            Text("Age: \(player.age!)")
                            Text("Nationality: \(player.nationality!)")
                        }
                        
                        ForEach(statistics) { statistic in
                            if statistic.league?.id == selection?.id {
                                
                                Text("General Statistics").bold()
                                ScrollView {
                                    if let games = statistic.games, let rating = games.rating, let appearances = games.appearences, let position = games.position {
                                        Text("Appearances: \(appearances)")
                                        Text("Average Rating: \(rating)")
                                        Text("Position: \(position)")
                                    }
                                }
                                
                                Text("Goals/Assists").bold()
                                ScrollView {
                                    if let goals = statistic.goals, let total = goals.total, let assists = goals.assists {
                                        Text("Goals: \(total)")
                                        Text("Assists: \(assists)")
                                    }
                                }
                                
                                Text("Passes").bold()
                                ScrollView {
                                    if let passes = statistic.passes, let total = passes.total, let key = passes.key, let accuracy = passes.accuracy {
                                        Text("Total: \(total)")
                                        Text("Key Passes: \(key)")
                                        Text("Accuracy: \(accuracy)%")
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
//    @ViewBuilder
//    var someasdfasdf: some View {
//        
//    }
    
}
