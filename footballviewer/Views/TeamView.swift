//
//  TeamView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/29/24.
//  Reference:
//  https://stackoverflow.com/questions/26719744/swift-sort-array-of-objects-alphabetically
//

import SwiftUI

struct TeamView: View {
    var viewModel: ViewModel
    
    @Binding var selectedTeams: Set<SquadResponse.ID>

    var leagues: [League?]
    
    var teams: [SquadResponse]
    
    var body: some View {
        List(selection: $selectedTeams) {
            Section(header: Text("Teams")) {
                ForEach(teams.sorted(by: { $0.team?.name ?? "" < $1.team?.name ?? "" }), id: \.id) { team in
                    Text((team.team?.name)!)
                }
            }
        }
        .padding()
        .frame(maxHeight: 300)
    }
}
