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
    
    var leagues: [League?]
    
    @Binding var selectedLeagues: Set<League.ID>
    
    var body: some View {
        List(selection: $selectedLeagues) {
            Section(header: Text("Leagues")) {
                ForEach(leagues, id: \.?.id) { league in
                    Text(league?.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxHeight: 300)
    }
}
