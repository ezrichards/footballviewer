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
    
    var body: some View {
        VStack {
            HStack {
                Button("Query Players") {
                    //                Task {
                    //                    await viewModel.loadPlayers(withId:withSeasonId:)
                    //                }
                }
                Button("Query Teams") {
                    //                Task {
                    //                    await viewModel.loadTeams(withLeagueId:withSeasonId:)
                    //                }
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
                        Picker("", selection: $selection) {
                            ForEach(response) { response in
                                Text(response.league?.name ?? "undefined").tag(response.league)
                            }
                        }
                        .pickerStyle(.menu)
                        
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
