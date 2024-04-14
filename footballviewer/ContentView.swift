//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ViewModel()
    @State private var selection: League? = nil
    var season = 2023 // MARK: TODO maybe have a picker for season or textfield entry?
    
    @State private var teamOneSelection: Team? = nil
    @State private var teamTwoSelection: Team? = nil
    @State private var teamOne: SquadResponse? = nil
    @State private var teamTwo: SquadResponse? = nil

    var body: some View {
        VStack {
            HStack {
                Button("Query Players") {
                    //                Task {
                    //                    await viewModel.loadPlayers(withId:withSeasonId:)
                    //                }
                }
                Button("Fetch teams") {
                    //                Task {
                    //                    await viewModel.loadTeams(withLeagueId:withSeasonId:)
                    //                }
                    
                    Task {
                        if let selection = selection {
                            await viewModel.loadTeams(withLeagueId: selection.id!, withSeasonId: season)
                        }
                    }
                }
                Button("Query Leagues") {
                    Task {
                        //                    await viewModel.loadLeagues();
                        viewModel.loadLeaguesFromFile();
                    }
                }
            }
            .padding()
        }
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
                            print("selection changed")
                            
                            // query team or check if it exists?
                        }
                    
                        
                        if let selection = selection {
                            if let name = selection.name, let id = selection.id {
                                Text("Selected league: \(name)")
                                Text("Selected league id: \(id)")
                            }
                        }
                    }
                    
                    Text("Teams")
                    if let squads = viewModel.squads {
                        ScrollView {
                            ForEach(squads.response!) { squad in
                                Text(squad.team?.name ?? "undefined")
                            }
                        }
                        
                        // team 1 selection
                        if let response = squads.response {
                            Picker("Team One:", selection: $teamOneSelection) {
                                ForEach(response) { response in
                                    if let team = response.team {
                                        Text(team.name ?? "undefined").tag(response.team)
                                    }
                                }
                            }
                            .frame(maxWidth: 200)
                            .pickerStyle(.menu)
                            .onChange(of: teamOneSelection) { oldValue, newValue in
//                                print(oldValue?.name)
//                                print(newValue?.name)
                                teamOne = response.first(where: { $0.team?.name == newValue?.name })
                                
//                                Task {
//                                    viewModel.loadPlayers(withId: teamOne.id, withSeasonId: season)
//                                }
                                
                            }
                        }
                    }


                    ScrollView {
                        if let players = teamOne?.players {
                            ForEach(players) { player in
                                Text(player.name ?? "undefined")
                            }
                        }
                    }
                    
                    
                    // team 2 selection
                    
                }
            }
//            GraphView()
        }
        .frame(maxHeight: .infinity)
    }
}
