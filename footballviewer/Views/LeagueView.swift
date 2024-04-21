//
//  LeagueView.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/21/24.
//

import SwiftUI

struct LeagueView: View {

    @Binding var viewModel: ViewModel
//    @StateObject var leaguesViewModel = LeaguesViewModel()
    
    var body: some View {
        if let leagueJson = viewModel.leagues {
            if let response = leagueJson.response {
                Picker("Select a league:", selection: $viewModel.selectedLeague) {
                    Text("No league selected").tag(nil as League?)
                    ForEach(response) { response in
                        if let countryName = response.country?.name {
                            Text("\(response.league?.name ?? "undefined") (\(countryName))").tag(response.league)
                        }
                    }
                }
                .frame(maxWidth: 250)
                .pickerStyle(.menu)
            }
        }

    }
}
