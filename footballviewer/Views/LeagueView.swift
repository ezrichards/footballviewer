//
//  LeagueView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/21/24.
//  Reference: https://stackoverflow.com/questions/66521632/swiftui-picker-binding-not-updating-when-picker-changes
//

import SwiftUI

struct LeagueView: View {
    var viewModel: ViewModel
    
    @Binding var selectedLeagues: Set<League.ID>

    var leagues: [League?]
    
    var body: some View {
        List(selection: $selectedLeagues) {
            Section(header: Text("Leagues")) {
                ForEach(leagues, id: \.?.id) { league in
                    Text(league?.name ?? "")
                }
            }
        }
//        .onChange(of: selectedLeagues) {
            // MARK: TODO this shouldn't be necessary
//                        print("selectedleagues changed:", selectedLeagues)
//            viewModel.leagueSelection = selectedLeagues
//        }
        .padding()
        .frame(maxHeight: 300)
    }
}
