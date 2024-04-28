//
//  LeagueView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/21/24.
//  Reference: https://stackoverflow.com/questions/66521632/swiftui-picker-binding-not-updating-when-picker-changes
//

import SwiftUI

struct LeagueView: View {
    @Binding var selectedLeague: League?
    
    var leagues: [League?]
    
    var body: some View {
        EmptyView()
//        Picker("Select a league:", selection: $selectedLeague) {
//            Text("No league selected").tag(nil as League?)
//            ForEach(leagues, id: \.?.id) { league in
//                Text("\(league?.name ?? "undefined")").tag(league)
//            }
//        }
//        .frame(maxWidth: 250)
//        .pickerStyle(.menu)
    }
}
