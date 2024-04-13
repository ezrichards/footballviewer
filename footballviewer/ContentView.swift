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
                // reference: https://www.linkedin.com/pulse/keypath-swift-usage-sergey-leschev/
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

//                        ScrollView {
//                            ForEach(response) { response in
//                                Text(response.league?.name ?? "undefined")
//                            }
//                        }

                        //                    Table(response) {
                        //                        let name = response[keyPath: \Response.league?.name]
                        
                        //                        TableColumn("Test", value: name as! KeyPath<Response, String>)
                        //                    }
                        //                    .padding()
                    }
                }
                
                //            Table(students, sortOrder: $sortOrder) {
                //                TableColumn("Student Name", value: \.name)
                //                TableColumn("Student ID", value: \.studentID)
                //                TableColumn("Student Score", value: \.overAllScore) {
                //                    Text(String(format: "%.2f", $0.overAllScore))
                //                }
                //                TableColumn("Letter Grade", value: \.letterGrade) {
                //                    Text($0.letterGrade.rawValue)
                //                }
                //            }
            }
            GraphView()
        }
        
        .frame(maxHeight: .infinity)
    }
}
