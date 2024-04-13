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



////
////  ContentView.swift
////  footballviewer
////
////  Created by Ethan Richards on 3/29/24.
////
//
//import SwiftUI
//
//struct ContentView: View {
//
//    @StateObject var viewModel = ViewModel()
//    @State var leagues: LeagueJson?
//    
//    var body: some View {
//        VStack {
//            Button("Query Players") {
////                Task {
////                    await viewModel.loadPlayers(withId:withSeasonId:)
////                }
//            }
//            Button("Query Teams") {
////                Task {
////                    await viewModel.loadTeams(withLeagueId:withSeasonId:)
////                }
//            }
//            Button("Query Leagues") {
//                leagues = viewModel.loadLeagues()
//            }
//
//            if let leagueJson = leagues {
//                // reference: https://www.swiftyplace.com/blog/chy7hvne
//                Table(leagueJson.response![0].seasons!) {
//                    
//                    // reference: https://stackoverflow.com/questions/64735876/convert-uuid-to-string-representation-eg-1816-to-cycling-speed-and-cadence
//                    TableColumn("Test", value: \.id.uuidString)
//                    
////                    TableColumn("Student Name", value: String(describing: \.id))
//                }
//                .frame(minWidth: .infinity)
//                .padding()
//            }
//
//            
//            
////            Table(students, sortOrder: $sortOrder) {
////                TableColumn("Student Name", value: \.name)
////                TableColumn("Student ID", value: \.studentID)
////                TableColumn("Student Score", value: \.overAllScore) {
////                    Text(String(format: "%.2f", $0.overAllScore))
////                }
////                TableColumn("Letter Grade", value: \.letterGrade) {
////                    Text($0.letterGrade.rawValue)
////                }
////            }
//            
////            VSplitView {
////                Text("Detail View").padding()
////            }
////            .frame(maxHeight: .infinity)
//        }
//        .padding()
//    }
//}
//
