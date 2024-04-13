//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
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
                    viewModel.loadLeaguesFile();
                }
            }

            // reference: https://www.linkedin.com/pulse/keypath-swift-usage-sergey-leschev/
            if let leagueJson = viewModel.leagues {
                if let response = leagueJson.response {
                    ScrollView {
                        ForEach(response) { response in
                            Text(response.league?.name ?? "undefined")
                        }
                    }
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

            VSplitView {
                Text("Detail View").padding()
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
    }
}
