//
//  LeaguesViewModel.swift
//  FootballViewer
//
//  Created by Ethan Richards on 4/14/24.
//

import Foundation

class LeaguesViewModel: ObservableObject {
    
    @Published var selectedLeague: League? = nil
    
    func updateSelection(newSelection: League?) {
        selectedLeague = newSelection
    }
    
    //    func getLeagueById(_ id: Int) -> League? {
    //        if let leagues = viewModel.leagues, let response = leagues.response {
    //            return response.first(where: { $0.league?.id == Int(id) })?.league
    //        }
    //        return nil
    ////        return viewModel.leagues?.response?.first(where: { $0.league.id == Int(id)})?.league
    ////        return viewModel.leagues?.response?.first(where: { $0.league?.id == Int(id) })
    //    }
}
