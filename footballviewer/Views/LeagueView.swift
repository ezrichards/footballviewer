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
//        if let leagueJson = viewModel.leagues {
//            if let response = leagueJson.response {
//                Picker("Select a league:", selection: $viewModel.selectedLeague) {
//                    Text("No league selected").tag(nil as League?)
//                    ForEach(response) { response in
//                        if let countryName = response.country?.name {
//                            Text("\(response.league?.name ?? "undefined") (\(countryName))").tag(response.league)
//                        }
//                    }
//                }
//                .frame(maxWidth: 250)
//                .pickerStyle(.menu)
//            }
//        }

        Picker("Select a league:", selection: $selectedLeague) {
            Text("No league selected").tag(nil as League?)
            ForEach(leagues, id: \.?.id) { league in
//                if let league = league, let name = league.name {
//                    Text("\(league.name ?? "")").tag(league.name)
//                }
                
                Text("\(league?.name ?? "")").tag(league)
                
//                if let countryName = response.country.name {
//                    Text("\(response.league?.name ?? "undefined") (\(countryName))").tag(response.league)
//                }
                
            }
        }
        .frame(maxWidth: 250)
        .pickerStyle(.menu)
   
        
        
    }
}
