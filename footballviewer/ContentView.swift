//
//  ContentView.swift
//  footballviewer
//
//  Created by Ethan Richards on 3/29/24.
//

import SwiftUI

struct ContentView: View {

    let viewModel = ViewModel()
    
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
                    await viewModel.loadLeagues();
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
            
//            TableColumn("Given name", value: \.givenName) { person in
//                Text(person.givenName)
//            }
            
            VSplitView {
                Text("Detail View").padding()
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
    }
}

