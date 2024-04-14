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
//

import SwiftUI

struct ContentView: View {
    
    var season = 2023 // MARK: TODO maybe have a picker for season or textfield entry?
    @StateObject var viewModel = ViewModel()
    @State private var selection: League? = nil
    @State private var teamOneSelection: Team? = nil
    @State private var teamTwoSelection: Team? = nil
    @State private var teamOne: SquadResponse? = nil
    @State private var teamTwo: SquadResponse? = nil
    
    func callTask() {
        print("called")
        Task {
            await viewModel.loadSquad(teamId: teamOneSelection?.id ?? 0)
        }
    }
    
    var body: some View {
        VStack {
            Button("Fetch teams") {
                Task {
                    if let selection = selection {
                        await viewModel.loadTeams(withLeagueId: selection.id!, withSeasonId: season)
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
                        
                        if let selection = selection {
                            if let name = selection.name, let id = selection.id {
                                Text("Selected league: \(name)")
                                Text("Selected league id: \(id)")
                            }
                        }
                    }
                    
                    Text("Teams")
                    teamPicker

                    if let players = viewModel.teamOnePlayers {
                        ScrollView {
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
    
    @ViewBuilder
    var teamPicker: some View {
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
                .onChange(of: teamOneSelection) { oldValue, newValue in
                    teamOne = response.first(where: { $0.team?.name == newValue?.name })
                }
                .onReceive([self.$teamOneSelection].publisher.first()) { newValue in
                    print(newValue.wrappedValue)
                    print(teamOneSelection)
                    print(teamOne)
//                    if newValue.wrappedValue != teamOne?.team {
                        callTask()
//                    }
                }
            }
        }
    }
}
