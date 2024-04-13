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
    var season = 2023
    
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
                }
            }
            GraphView()
        }
        
        .frame(maxHeight: .infinity)
    }
}
