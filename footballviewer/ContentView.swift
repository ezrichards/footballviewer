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
    
    @State private var selectedPlayerOne: Players? = nil
    @State private var selectedPlayerTwo: Players? = nil
    
    var body: some View {
        HStack {
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
                                toggled.toggle()
                            }
                            .onReceive([self.$teamOneSelection].publisher.first()) { newValue in
                                if toggled {
                                    Task {
                                        teamOnePlayers = await viewModel.loadSquad(teamId: teamOneSelection?.id ?? 0)
                                    }
                                    toggled.toggle()
                                }
                            }
                            
                            if let players = teamOnePlayers {
                                ScrollView {
                                    ForEach(players) { player in
                                        Text(player.name ?? "undefined")
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
                    
                    // team 2 selection
                    
                }
            }
//            GraphView()
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
